//
// softfloat_div.c
// james.stine@okstate.edu 12 April 2023
// 
// Demonstrate using SoftFloat do compute 754 fp divide, then print results
// (adapted from original C built by David Harris)
//

#include <stdio.h>
#include <stdint.h>
#include "softfloat.h"
#include "softfloat_types.h"
typedef union sp {
  uint32_t v;
  unsigned short x[2];
  float f;
} sp;

void long2binstr(unsigned long  val, char *str, int bits) {
  int i, shamt;
  unsigned long mask, masked;

  if (val == 0) { // just return zero
    str[0] = '0';
    str[1] = 0; 
  } else {
    for (i=0; (i<bits); i++) {
      shamt = bits - i - 1;
      mask = 1;
      mask = (mask << shamt); 
      masked = val & ~mask; // mask off the bit
      if (masked != val) str[i] = '1';
      else str[i] = '0';
      val = masked;
    }
    // (debug)
    // printf("long2binstr %lx %s %d\n", val, str, bits);    
  } 
}

void printFlags(void) {
  int NX = softfloat_exceptionFlags % 2;
  int UF = (softfloat_exceptionFlags >> 1) % 2;
  int OF = (softfloat_exceptionFlags >> 2) % 2;
  int DZ = (softfloat_exceptionFlags >> 3) % 2;
  int NV = (softfloat_exceptionFlags >> 4) % 2;
  printf ("Flags: Inexact %d Underflow %d Overflow %d DivideZero %d Invalid %d\n", 
          NX, UF, OF, DZ, NV);
}

void softfloatInit(void) {
    // RNE: softfloat_round_near_even
    // RZ:  softfloat_round_minMag
    // RU:  softfloat_round_max
    // RD:  softfloat_round_min
    // RM: softfloat_round_near_maxMag   
    softfloat_roundingMode = softfloat_round_near_even; 
    softfloat_exceptionFlags = 0; // clear exceptions
    softfloat_detectTininess = softfloat_tininess_afterRounding; // RISC-V behavior for tininess
}

void printF32(char *msg, float32_t f) {
  sp conv;
  long exp, fract;
  char sign;
  char sci[200], fractstr[200];

  conv.v = f.v; // use union to convert between hexadecimal and floating-point views
  fract = f.v & ((1<<23) - 1);
  long2binstr(fract, fractstr, 23);
  exp = (f.v >> 23) & ((1<<8) -1);
  sign = f.v >> 31 ? '-' : '+';
  if (exp == 0 && fract == 0) sprintf(sci, "%czero", sign);
  else if (exp == 0 && fract != 0) sprintf(sci, "Denorm: %c0.%s x 2^-126",
					   sign, fractstr);
  else if (exp == 255 && fract == 0) sprintf(sci, "%cinf", sign);
  else if (exp == 255 && fract != 0) sprintf(sci, "NaN Payload: %c%s",
					     sign, fractstr);
  else sprintf(sci, "%c1.%s x 2^%ld", sign, fractstr, exp-127);

  printf("%s: ", msg);
  printf("0x%04x", (conv.v >> 16));
  printf("_");
  printf("%04x", (conv.v & 0xFFFF));
  printf(" = %g = %s: Biased Exp %ld Fract 0x%lx\n", conv.f, sci, exp, fract);
}

int main() {

  // float32_t is typedef in SoftFloat
  float32_t x, y, r1, r2;
  sp convx, convy;

  // Choose two random values
  convx.f = 1.30308703073;
  convy.f = 1.903038030370;
  //4BF7BFFF_DA7EEFFF_B0F8C855_01
  x.v = 0xBE5FEFFF;
  y.v = 0x417FEBFF;
  // Convert to SoftFloat format
  //x.v = (convx.x[1] << 16) + convx.x[0];
  //y.v = (convy.x[1] << 16) + convy.x[0];

  printf("Example using SoftFloat\n");
  
  softfloatInit();
  r1 = f32_div(x, y);
  printf("-------\n");
  printF32("X", x);
  printF32("Y", y); 
  printF32("result = X/Y", r1);
  printFlags();

  r2 = f32_sqrt(x);
  printf("-------\n");    
  printF32("X", x);
  printF32("result = sqrt(X)", r2);
  printFlags();  

}
