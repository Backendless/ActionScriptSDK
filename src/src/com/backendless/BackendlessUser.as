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
package com.backendless
{
  public class BackendlessUser
  {
    public static const PASSWORD:String = "password";
    public static const EMAIL:String = "email";

    private var _properties:Object = {};

    public function BackendlessUser()
    {
      _properties[ "___class" ] = "Users";
    }

    public function get password():String
    {
      return getProperty( PASSWORD );
    }

    public function set password( value:String ):void
    {
      setProperty( PASSWORD, value );
    }

    public function get email():String
    {
      return getProperty( EMAIL );
    }

    public function set email( value:String ):void
    {
      setProperty( EMAIL, value );
    }

    public function get objectId():String
    {
      return getProperty( "objectId" );
    }

    public function set objectId( value:String ):void
    {
      setProperty( "objectId", value );
    }

    public function setProperty( key:String, value:* ):void
    {
      _properties[key] = value;
    }

    public function getProperty( key:String ):*
    {
      return _properties[key];
    }

    public function removeProperty( key:String ):void
    {
      delete _properties[ key ];
    }

    public function get properties():Object
    {
      return _properties;
    }

    public function validate():void
    {
      //ArgumentValidator.notNull( password, "Password value can't be null" );
      //ArgumentValidator.notEmpty( password, "Password value can't be an empty string" );
    }
  }
}