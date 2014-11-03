/*                                                                                                                                                                           
 * ********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 * ********************************************************************************************************************
 *
 *   Copyright 2012 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE:  All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any.  The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 * *******************************************************************************************************************
 */
package com.backendless.service
{
  import com.backendless.Backendless;
  import com.backendless.rpc.BackendlessClient;
  import com.backendless.upload.FileServiceActionResult;
  import com.backendless.upload.events.FileUploadFaultEvent;
  import com.backendless.upload.events.FileUploadResultEvent;
  import com.backendless.validators.ArgumentValidator;

  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.FileReference;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  import flash.utils.ByteArray;

  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;
  import mx.rpc.Responder;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  import mx.utils.UIDUtil;

  public class _FileService extends BackendlessService
  {
    private static const SERVICE_SOURCE:String = "com.backendless.services.file.FileService";

    private static const INVALID_CHARACTERS:Array = ["\\", "/", ":", "*", "?", "<", ">", "\"", "|"];

    private static const SERVICE_URL_PART:String = "files";
    private static const PATH_SEPARATOR:String = "/";
    private static const ACTION_ID:String = "action-id";

    private var _actionId:String;
    private var _uploading:Boolean = false;

    /**
     * Uploads the given file to the specified path on the server side
     *
     * <p>The function uploads the given file for the current application
     * version into the specified path of the server repository.</p>
     *
     * <p>The function will dispatch the FileUploadResultEvent event if
     * the file is successfully uploaded. The uploadId parameter is an
     * optional and helps to unambiguously distinguish the upload result.
     * The result event contains a full URL path where the uploaded file is accessible</p>
     *
     * <p>If the given file with the provided path already exists in the server repository,
     * an error will occur</p>
     *
     * <p>If an error occurs during the upload, the FileUploadFaultEvent fault event is dispatched.
     * The fault event has an uploadId parameter as well</p>
     *
     * @param file an instance of the FileReference class to upload
     * @param path a save path on the server side for the file
     * @param uploadId an unique, optional action identifier to unambiguously distinguish the upload result
     */
    public function upload( file:FileReference, path:String, uploadId:String = null ):void
    {
      ArgumentValidator.notNull( path );
      ArgumentValidator.notEmpty( path );
      ArgumentValidator.validate( path, pathIsValid, 'A path cannot contain any of the following characters: \\/:*?"<>|' );

      if( !_uploading )
      {
        _actionId = (null == uploadId) ? getActionId() : uploadId;
        _uploading = true;
      }

      var request:URLRequest = getUrlRequest( getOperationEndpoint( path, file.name ) );

      file.addEventListener( Event.COMPLETE, function ( event:Event ):void
      {
        getActionStatus();
      } );

      file.addEventListener( IOErrorEvent.IO_ERROR, function ( event:IOErrorEvent ):void
      {
        _uploading = false;
        dispatchEvent( new FileUploadFaultEvent( _actionId, "an io error has occured", event ) );
      } );

      file.addEventListener( SecurityErrorEvent.SECURITY_ERROR, function ( event:SecurityErrorEvent ):void
      {
        _uploading = false;
        dispatchEvent( new FileUploadFaultEvent( _actionId, "a security exception has occurred", event ) );
      } );

      try
      {
        file.upload( request );
      }
      catch( error:Error )
      {
        _uploading = false;
        dispatchEvent( new FileUploadFaultEvent( _actionId, "an unexpected error has occured" ) );
      }
    }

    public function saveFile( path:String, filename:String, fileContent:ByteArray, overwrite:Boolean,
                              responder:IResponder = null ):AsyncToken
    {
      var args:Array = [Backendless.appId, Backendless.version, path, filename, fileContent, overwrite ];
      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "saveFile", args );
      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           if( responder )
                                             responder.result( event );
                                         },
                                         function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );

      return token;
    }

    private function getActionStatus():void
    {
      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "getActionStatus", [_actionId] );
      token.addResponder( new Responder( onGetActionStatusResult, onGetActionStatusFault ) );
    }

    private function onGetActionStatusResult( event:ResultEvent ):void
    {
      _uploading = false;

      var result:FileServiceActionResult = event.result as FileServiceActionResult;

      if( result.error )
      {
        dispatchEvent( new FileUploadFaultEvent( _actionId, result.message ) );
      }
      else
      {
        dispatchEvent( new FileUploadResultEvent( _actionId, result.message ) );
      }
    }

    private function onGetActionStatusFault( event:FaultEvent ):void
    {
      _uploading = false;
      dispatchEvent( new FileUploadFaultEvent( _actionId, "an io error has occured", event ) );
    }

    public function removeFile( fileLocation:String, responder:IResponder = null ):AsyncToken
    {
      return remove( fileLocation, responder );
    }

    public function removeDirectory( directoryLocation:String, responder:IResponder = null ):AsyncToken
    {
      return remove( directoryLocation, responder );
    }

    private function remove( fileOrDirectoryLocation:String, responder:IResponder = null ):AsyncToken
    {
      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "deleteFileOrDirectory", [Backendless.appId, Backendless.version, fileOrDirectoryLocation] );
      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           if( responder ) responder.result( event );
                                         }, function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );

      return token;
    }

    private function getUrlRequest( url:String ):URLRequest
    {
      var request:URLRequest = new URLRequest( url );
      request.method = URLRequestMethod.POST;
      request.data = getURLVariables();
      return request;
    }

    private function getURLVariables():URLVariables
    {
      var variables:URLVariables = new URLVariables();

      variables[Backendless.APPLICATION_ID_HEADER] = Backendless.headers[Backendless.APPLICATION_ID_HEADER];
      variables[Backendless.SECRET_KEY_HEADER] = Backendless.headers[Backendless.SECRET_KEY_HEADER];
      variables[Backendless.APPLICATION_TYPE_HEADER] = Backendless.headers[Backendless.APPLICATION_TYPE_HEADER];
      variables[ACTION_ID] = _actionId;

      return variables;
    }

    private function getOperationEndpoint( path:String, name:String = null ):String
    {
      var result:String = Backendless.SITE_URL + Backendless.version + PATH_SEPARATOR + SERVICE_URL_PART + PATH_SEPARATOR + path;

      if( name != null )
      {
        result += PATH_SEPARATOR + name;
      }

      trace( result );
      return result;
    }

    public function getActionId():String
    {
      return UIDUtil.createUID();
    }

    private function pathIsValid( path:String ):Boolean
    {
      for each ( var s:String in INVALID_CHARACTERS )
      {
        if( path.indexOf( s ) != -1 )
          return false;
      }

      return true;
    }
  }
}