#ifndef _MRUBY_HPP_
#define _MRUBY_HPP_

#include <emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>
#include <stdio.h>
#include <math.h>
#include <mruby.h>
#include <mruby/array.h>
#include <mruby/class.h>
#include <mruby/data.h>
#include <mruby/proc.h>
#include <mruby/string.h>
#include <mruby/value.h>
#include <mruby/variable.h>
#include <mruby.h>
#include <mruby/irep.h>


#include <mruby/dump.h>


class MRuby
{

  public:
  
  static void initialize();
  static bool is_alive();
  static void load_bytecode(emscripten::val bytecode_js);
  static void load_source(std::string rb_source);
  
  private:
  
  static mrb_state* _mrb;
  static mrbc_context* _context;
  
  static void halt_on_error();
  
};


extern "C"
void mrb_bruby_mruby_interpreter_gem_init(mrb_state* mrb);


extern "C"
void mrb_bruby_mruby_interpreter_gem_final(mrb_state* mrb);

#endif
