(function(){

  BRubyBridge.RbInterface = Module.RbInterface;

  var RbInterface = BRubyBridge.RbInterface;


  // Object.defineProperty(RbInterface, 'Object', { get: function() {
  //   return this._Object = this._Object || this.get_object_class();
  // } });


  var old_string_method = RbInterface.string;
  RbInterface.string = function(string_js = "")
  {
    return old_string_method.bind(this)(string_js);
  };

  
  var old_send_method = RbInterface.prototype.send;
  RbInterface.prototype.send = function(method_name_js, ...arguments_js)
  {
    return old_send_method.bind(this)(method_name_js, arguments_js);
  };


})();


// TODO: remove this when better solution is available
// temporary life cycle management solution
(function(){
  var RbInterface = BRubyBridge.RbInterface;
  
  RbInterface.protected_interfaces = [];
  RbInterface.unprotected_interfaces = [];
  
  forget_old_ruby_objects = function()
  {
    let interfaces = RbInterface.unprotected_interfaces.slice();
    interfaces.forEach(interface => interface.forget() );
  };

  RbInterface.prototype.protect = function()
  {
    var index = RbInterface.unprotected_interfaces.indexOf(this);
    if (index !== -1)
      RbInterface.unprotected_interfaces.splice(index, 1);
    RbInterface.protected_interfaces.push(this);
  };

  RbInterface.prototype.unprotect = function()
  {
    var index = RbInterface.protected_interfaces.indexOf(this);
    if (index !== -1)
      RbInterface.protected_interfaces.splice(index, 1);
    RbInterface.unprotected_interfaces.push(this);
  };
  
  var old_forget_method = RbInterface.prototype.forget;
  RbInterface.prototype.forget = function(...args)
  {
    if (this.stale)
      throw new Error('the reference to this ruby object is stale');
    var index = RbInterface.unprotected_interfaces.indexOf(this);
    if (index !== -1)
      RbInterface.unprotected_interfaces.splice(index, 1);
    var index = RbInterface.protected_interfaces.indexOf(this);
    if (index !== -1)
      RbInterface.protected_interfaces.splice(index, 1);
    old_forget_method.bind(this)(...args);
    this.stale = true;
  };

  var old_send_method = RbInterface.prototype.send;
  RbInterface.prototype.send = function(...args)
  {
    if (this.stale || args.some(arg => arg instanceof RbInterface && arg.stale))
      throw new Error('a reference to a ruby object is stale');
    return old_send_method.bind(this)(...args);
  };

  var old_to_boolean_method = RbInterface.prototype.to_boolean;
  RbInterface.prototype.to_boolean = function(...args)
  {
    if (this.stale)
      throw new Error('the reference to this ruby object is stale');
    return old_to_boolean_method.bind(this)(...args);
  };

  var old_to_number_method = RbInterface.prototype.to_number;
  RbInterface.prototype.to_number = function(...args)
  {
    if (this.stale)
      throw new Error('the reference to this ruby object is stale');
    return old_to_number_method.bind(this)(...args);
  };

  var old_to_string_method = RbInterface.prototype.to_string;
  RbInterface.prototype.to_string = function(...args)
  {
    if (this.stale)
      throw new Error('the reference to this ruby object is stale');
    return old_to_string_method.bind(this)(...args);
  };

  window.Object.defineProperty(RbInterface, 'Object', { get: function() {
    if (!this._Object)
    {
      this._Object = this.get_object_class();
      this._Object.protect();
    }
    return this._Object;
  } });

})();


//ESRubyInterface.RbValue.eval(code)
//{
//  return this.kernel.send("eval", [code]);
//}