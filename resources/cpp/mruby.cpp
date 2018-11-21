#include "mruby.hpp"

using namespace std;
using namespace emscripten;


mrb_state* MRuby::_mrb = nullptr;
mrbc_context* MRuby::_context = NULL;


bool MRuby::is_alive()
{
  return _mrb != nullptr;
}


void MRuby::halt_on_error()
{
  if (_mrb->exc)
  {
    mrb_print_error(_mrb);
    _mrb->exc = NULL;
    _mrb = nullptr;
    val::global("Error").new_(val("ruby error encountered, halting interpreter")).throw_();
  }
}


void MRuby::initialize()
{
  if (_mrb)
    val::global("Error").new_(val("interpreter already alive")).throw_();
  _mrb = mrb_open();
  if (!_mrb)
    val::global("Error").new_(val("error opening new mrb state")).throw_();

  halt_on_error();
}


void MRuby::load_bytecode(val bytecode_js)
{
  if (!_mrb)
    val::global("Error").new_(val("interpreter not alive")).throw_();

  vector<uint8_t> bytecode = vecFromJSArray<uint8_t>(bytecode_js);

  // mrb_load_irep expects the irep as a literal
  uint8_t* irep_ptr = (uint8_t*)mrb_malloc(_mrb, sizeof(uint8_t) * bytecode.size());
  if (irep_ptr == nullptr)
    val::global("Error").new_(val("not enough memory to load ruby srouce, halting interpreter")).throw_();
  copy(bytecode.begin(), bytecode.end(), irep_ptr);
  // no need to free the irep later, so don't need to keep track of the pointer

  mrb_load_irep_cxt(_mrb, irep_ptr, _context);

  halt_on_error();
}


void MRuby::load_source(string rb_source)
{
  if (!_mrb)
    val::global("Error").new_(val("interpreter not alive")).throw_();
  
  mrbc_context *c = NULL;
  
  c = mrbc_context_new(_mrb);
  
  //TODO: use heap faster?
  mrb_load_string_cxt(_mrb, rb_source.c_str(), c);

  halt_on_error();
  mrbc_context_free(_mrb, c);
}


void mrb_bruby_mruby_interpreter_gem_init(mrb_state* mrb)
{
}


void mrb_bruby_mruby_interpreter_gem_final(mrb_state* mrb)
{
}


EMSCRIPTEN_BINDINGS(mruby)
{
  emscripten::class_<MRuby>("MRuby")
    .class_function("is_alive", &MRuby::is_alive)
    .class_function("initialize", &MRuby::initialize)
    .class_function("load_source", &MRuby::load_source)
    .class_function("load_bytecode", &MRuby::load_bytecode)
  ;
}







// void ESRuby::shutdown()
// {
//   printf("--- SHUTDOWN ---\n");
//   if (!is_alive())
//   {
//     printf("Error: esruby not alive\n");
//     throw std::runtime_error("Error: esruby not alive");
//   }
//   mrb_close(_mrb);
//   // print error if any
//   if (_mrb->exc)
//   {
//     mrb_print_error(_mrb);
//     _mrb = nullptr;
//     throw std::runtime_error("ruby error encountered on interpreter shutdown");
//   }
//   _mrb = nullptr;
// }