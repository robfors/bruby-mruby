(function() {
  var global = (typeof global == 'undefined' ? window : global);

  if (typeof Extraneous == 'undefined')
    throw new Error("extraneous not ready");


  var mruby = {};
  
  mruby.initialize = function()
  {
    Module.MRuby.initialize();
  };

  mruby.load = function(source)
  {
    if (source.type == 'ruby')
    {
      var code = new Extraneous.Code(source.code);
      Module.MRuby.load_bytecode(code.to_binary());
    }
    //else if (source.type == 'mrbc')
    //  Module.MRuby.load_bytecode(source.code.to_binary();
    else
      throw new Error("unknown source type");
  };

  mruby.types = ['ruby', 'mrbc'];


  Extraneous.load_interpreter(mruby);


})();