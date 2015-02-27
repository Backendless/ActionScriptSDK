package com.backendless.validators
{
  import com.backendless.errors.InvalidArgumentError;

  import mx.collections.ArrayCollection;

  public class ArgumentValidator
  {
    private static const DEFAULT_NULL:String = "the value cannot be null";
    private static const DEFAULT_EMPTY:String = "the value cannot be empty";
    private static const DEFAULT_EMPTYARRAY:String = "the collection cannot be empty";
    private static const DEFAULT_NEGATIVE:String = "the value cannot be negative";
    private static const DEFAULT_VALIDATE:String = "the value not passed validation";
    private static const DEFAULT_GREATERZERO:String = "the value must be greater than zero";

    public static function notNull( property:*, message:String = null ):void
    {
      if( property == null )
        throw new InvalidArgumentError( (null == message) ? DEFAULT_NULL : message );
    }

    public static function notEmpty( property:*, message:String = null ):void
    {
      if( property is Array && (property as Array).length == 0 )
        throw new InvalidArgumentError( (null == message) ? DEFAULT_EMPTYARRAY : message );

      if( property is ArrayCollection && (property as ArrayCollection).length == 0 )
        throw new InvalidArgumentError( (null == message) ? DEFAULT_EMPTYARRAY : message );

      if( property == "" )
        throw new InvalidArgumentError( (null == message) ? DEFAULT_EMPTY : message );
    }

    public static function notNegative( value:Number, message:String = null ):void
    {
      if( value < 0 )
        throw new InvalidArgumentError( (null == message) ? DEFAULT_NEGATIVE : message );
    }

    public static function validate( value:*, validateFunction:Function, message:String = null ):void
    {
      if( !validateFunction( value ) )
        throw new InvalidArgumentError( (null == message) ? DEFAULT_VALIDATE : message );
    }

    public static function greaterThanZero( value:Number, message:String ):void
    {
      if( value <= 0 )
        throw new InvalidArgumentError( (null == message) ? DEFAULT_GREATERZERO : message );
    }
  }
}