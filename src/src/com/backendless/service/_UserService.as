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
	import com.backendless.BackendlessUser;
	import com.backendless.core.backendless;
	import com.backendless.data.BackendlessCollection;
	import com.backendless.data.store.Utils;
	import com.backendless.helpers.ClassHelper;
	import com.backendless.helpers.ObjectsBuilder;
	import com.backendless.property.UserProperty;
	import com.backendless.rpc.BackendlessClient;
	import com.backendless.validators.ArgumentValidator;

  import flash.net.SharedObject;

  import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	use namespace backendless;
	
	/**
	 * Provides a number of methods to handle operations related to Backendless users
	 *
	 * @author Cyril Deba
	 */
	public class _UserService extends BackendlessService
	{
	
		private static const SERVICE_SOURCE:String = "com.backendless.services.users.UserService";
	
		private var _currentUser:BackendlessUser;
	
		/**
		 * Returns a collection of UserObject Properties
		 *
		 * @param responder - the custom responder
		 *
		 * @return BackendlessCollection - a list of UserProperty objects
		 *
		 * @see BackendlessCollection
		 * @see UserProperty
		 */
		public function describeUserClass(responder:IResponder = null):ArrayCollection
		{
			var result:BackendlessCollection = new BackendlessCollection(ClassHelper.getCanonicalClassName(UserProperty));
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "describeUserClass", 
				[Backendless.appId, Backendless.version]);
	
			token.addResponder(
				new Responder(
					function (event:ResultEvent):void
					{
						if (responder) responder.result(
							ResultEvent.createEvent( new ArrayCollection( event.result as Array ) )	
						);
 						result.bindSource(event.result);
					},
					function (event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			);

			return result;
		}
	
		/**
		 * Authenticates an user based on its login and password
		 *
		 * @param login - the user' login (either username or password)
		 * @param password - the user' password
		 * @param responder
		 *
		 * @return BackendlessUser - an instance of the BackendlessUser class that represents the authenticated user
		 */
		public function login(login:String, password:String, responder:IResponder = null, stayLoggedIn:Boolean = false):AsyncToken
		{
			ArgumentValidator.notNull(login);
			ArgumentValidator.notNull(password);
			ArgumentValidator.notEmpty(login);
			ArgumentValidator.notEmpty(password);
	
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "login",
				[Backendless.appId, Backendless.version, login, password]);
	
			token.addResponder(
				new Responder(
					function (event:ResultEvent):void
					{
						_currentUser = ObjectsBuilder.buildUser(event.result);
						//_currentUser.password = password;
                        var userToken:String = _currentUser.getProperty( Backendless.LOGGED_IN_KEY );
						Backendless.backendless::setUserToken( userToken );
						_currentUser.removeProperty( Backendless.LOGGED_IN_KEY );

                        if( stayLoggedIn )
                        {
                          var so:SharedObject = SharedObject.getLocal( "loginInfo" );
                          so.data.userToken = userToken;
                          so.data.userId = _currentUser.getProperty( "objectId");
                          so.flush();
                        }

                        if( responder )
                            responder.result( ResultEvent.createEvent( _currentUser, token,  event.message ) );
					},
					function (event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			);
	
			//token.addResponder(responder);
	
			return token;
		}

        public function isValidLogin( responder:IResponder ):void
        {
          var so:SharedObject = SharedObject.getLocal( "loginInfo" );

          var asyncToken:AsyncToken;

          if( so.data.userToken != undefined && so.data.userToken != null )
          {
            asyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "isValidUserToken", [Backendless.appId, Backendless.version, so.data.userToken] );

            if( responder != null )
              asyncToken.addResponder( responder );
          }
          else if( responder != null )
          {
            var evt:ResultEvent = new ResultEvent( ResultEvent.RESULT, false, true, currentUser != null );
            responder.result( evt );
          }
        }
	
		/**
		 * Invalidates the authenticated user
		 *
		 */
		public function logout(responder:IResponder = null ):AsyncToken
		{
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "logout",
				[Backendless.appId, Backendless.version]);
	
			token.addResponder(
				new Responder(
					function (event:ResultEvent):void
					{
						_currentUser = null;
						Backendless.backendless::removeUserToken();
                        var so:SharedObject = SharedObject.getLocal( "loginInfo" );
                        so.clear();
					},
					function (event:FaultEvent):void
					{
                        var faultCode:Number = Number( event.fault.faultCode );

                        if( faultCode != 3064 && faultCode != 3091 && faultCode != 3090 && faultCode != 3023 )
						  onFault(event, responder);
                        else
                        {
                          event.stopPropagation();
                          token.responders.splice(0);

                          if( responder != null )
                            responder.result( new ResultEvent( ResultEvent.RESULT ) );
                        }
					}
				)
			);

            if( responder != null )
			    token.addResponder(responder);
	
			return token;
		}
	
		/**
		 * Creates a new user
		 *
		 * @param candidate - an instance of the BackendlessUser class that represents a candidate to create
		 * @param responder
		 *
		 * @throws InvalidArgumentError if <code>candidate</code> is null
		 */
		public function register(candidate:BackendlessUser, responder:IResponder = null):AsyncToken
		{
			ArgumentValidator.notNull(candidate, "user cant be NULL");
			ArgumentValidator.notNull(candidate.getProperty("password"), "user's password cannot be NULL");
			ArgumentValidator.notEmpty(candidate.getProperty("password"), "user's password cannot be empty");
			//ArgumentValidator.notNull(candidate.getProperty("email"), "user's email cannot be NULL");
			//ArgumentValidator.notEmpty(candidate.getProperty("email"), "user's email cannot be empty");
	
			var token:AsyncToken = BackendlessClient.instance.invoke(
				SERVICE_SOURCE,
				"register",
				[
					Backendless.appId,
					Backendless.version,
					candidate.properties
				]
			);
	
			token.addResponder(
				new Responder(
					function (event:ResultEvent):void
					{
						if (responder)
						{
							responder.result(
								ResultEvent.createEvent(
									ObjectsBuilder.updateUser(candidate, event.result),
									token
								)
							)
						}
					},
					function (event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			);
	
			return token;
		}
	
		/**
		 * Restores the user password based on its identity property
		 *
		 * In case if the server-side is able to retrieve an user record based on the provided identity, it will send an
         * password recovery email to the user's email address
		 *
		 * @param identity - value of the user's identity property
		 * @param responder
		 */
		public function restorePassword(identity:String, responder:IResponder = null):AsyncToken
		{
			ArgumentValidator.notEmpty(identity);
			ArgumentValidator.notNull(identity);
	
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "restorePassword",
				[Backendless.appId, Backendless.version, identity]);
	
			token.addResponder(
				new Responder(
					function (event:ResultEvent):void
					{
						// handle it properly
					},
					function (event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			);

            if( responder != null )
			  token.addResponder(responder);
			
			return token;
		}
	
		/**
		 * Updates the existing user properties
		 *
		 * @throws InvalidArgumentError if candidate is NULL
		 */
		public function update(user:BackendlessUser, responder:IResponder = null):AsyncToken
		{
			ArgumentValidator.notNull(user);
			user.validate();
			com.backendless.data.store.Utils.addClassName( user.properties, true );

            if( user.password == null )
              delete user.properties[ BackendlessUser.PASSWORD ];
	
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "update",
				[Backendless.appId, Backendless.version, user.properties]);
	
			token.addResponder(
				new Responder(
					function (event:ResultEvent):void
					{
						if (responder) responder.result(
							ResultEvent.createEvent(ObjectsBuilder.updateUser(user, event.result), token)
						);
					},
					function (event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			);
			
			return token;
		}
	
		public function get currentUser():BackendlessUser
		{
			return _currentUser;
		}
	}
}