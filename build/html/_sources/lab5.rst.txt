.. ECE 4703 

Lab 5 
=====

The purpose of this assignment is as follows.

* to analyze the assembly code of a 6-stage biquad filter,
* to analyze the impact of compiler optimization on the assembly code,
* to build a version of this filter using the ARM CMSIS library,
* to compare the performance of these filters under different compiler optimization levels.

.. important::

   To implement this lab, you can start from the code developed for Lab 3.
   If you were unable to build the code for this lab, contact the TA or the 
   instructor to receive a sample solution.

Designing a 6th order elliptic bandpass filter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The filter that you will implement and study for this lab has the following specifications.

* Sample frequency: 32 KHz
* Elliptic IIR Bandpass Type
* Passband: 3500 Hz to 4500Hz
* Stopband 1: DC - 3300 Hz
* Stopband 2: 4700 Hz - fs/2
* Passband ripple < 1dB
* Stopband suppression > 60dB
* Floating Point (single-precision) design

Compared to filters we created earlier, this is a rather challenging specification because of the steepness of the transition bands. Use Matlab's ``filterDesigner`` to create this filter's coefficients. You should be able to show that this filter requires a 12th order design, which can be implemented using 6 biquad stages.

Your first task is to implement this filter in a C program for your MSP432 kit. You can build your implementation based on the solutions you created for Lab 3; simply substitute the new coefficients in the old filter, and adjust the design to use the proper number of biquad filter stages.
You can refer to this `solved Lab 3 on Github <https://github.com/wpi-ece4703-b20/assignment3_solved>`_, in case you don't have fully solved Lab 3. If you use this solved design, don't forget to
update the coefficients with the filter specs listed above!

Next, you have to optimize this 12th order filter using the C compiler under **two** different optimization settings. For each of the resulting implementations, you have to collect the following information.

Variant 1: Unoptimized Code
"""""""""""""""""""""""""""

1. Configure the compiler to disable all optimization *(Project Properties - CCS Build - 
   ARM Compiler - Optimization - Optimization Level Off)*. Compile the code.
   Collect the assembly listing for this design (main.lst) and set it aside for futher analysis later in this lab.

2. Run the code on your board and determine the sample rate achieved by the code by measuring the 
   sample frequency on the DAC SYNC pin. It is highly likely that your design will not run at the required 32 KHz, but at a lower frequency. This is because the ``processSample`` function
   consumes more cycles than are available in the sample period (1/(32 KHz)). 

3. Determine the clock cycle count needed to execute the processSample function.

If you find a frequency below 32 KHz, it means that your filter design is no longer running in real-time, and therefore will no longer implement the filter characteristic you designed earlier. When the sample rate of the filter is too slow, you can observe a shift of the passband when you measure the spectrum of the filter to noise. This is an optional experiment that you can perform after you completed steps 1-3 above.

Variant 2: Optimized Code
"""""""""""""""""""""""""""

1. Configure the compiler to compiler for speed and function inlining
   *(Project Properties - CCS Build - ARM Compiler - Optimization - 
   Interprocedure Optimizations - Optimize for Speed)*. Compile the code.
   Collect the assembly listing for this design (main.lst) and set it aside for futher analysis later in this lab.

2. Run the code on your board and determine the sample rate achieved by the code by measuring the 
   sample frequency of the DAC SYNC pin. It is expected that the optimized design can run at 
   the required
   32KHz sample rate. If it does not run fast enough, reconsider the C code to identify any glaring issues in inefficiency.

3. Determine the clock cycle count needed to execute the processSample function.

Assuming that the filter sample rate is fast enough (32KHz), you will be able to observe the spectrum of the filter at the correct frequencies given in the filter specification.

.. important::

   Question 1: Report on the cycle count observed for each case (unoptimized and optimized), and report on the observed sample frequency produced by the DAC SYNC pin. Please make sure that 
   your filter is operational, and that it is using the correct filter coefficients. 
   An easy (but optional) way demonstrate this, is to show a plot of  the filter spectrum, 
   as obtained using Bitscope.

Analyzing the assembly code
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Next, you have analyze the assembly listing files collected from compiling the code. 
The objective is to create a table similar to the asmtable_ discussed in Lecture 7.
This table will analyze the assembly code by counting assembly instructions. You will
collect the following information:

1. The number of instructions in the static program image. 
   This metric represents the cost of storing instructions.

2. The number of instructions executed to deal with data movement, 
   including address expressions, and load/store operations.

3. The number of instructions executed to deal with control, 
   including loop counting and branches.

4. The number of instructions executed for actual IIR calculations, such as 
   multiply and accumulate.

The analysis techniques are discussed in Lecture 7: you have to find a mapping between C and the assembly listing. Here are some guidelines.

* Whereas in Lecture 7 there was only a single sampleProcess function, with this new design, there may
  be nested function calls. For example, in the Lab 3 sample solution, the `sampleProcess()` function is calling
  six times a biquad section called `iir2()`. Therefore, you would apply the assembly code analysis to
  both `sampleProcess()` and `iir2()`. You do not have to analyze library code functions such as `adc14_to_f32()`,
  but you have to analyze all nested functions that you wrote yourself.

* Use an analysis process similar to the one discussed in Lecture 7. Start by looking for the 
  implementation of ``processSample``, and isolate the assembly instructions executed for that function as 
  well as the nest functions called by it. You have to perform an analysis that partitions the instructions
  in control-related instructions, data-movement related instructions, and compute-related instructions. In case you 
  are not sure about the category, please make an educated guess.

* The assembly code contains floating-point instructions, since the filter is running floating point precision.
  If you find instructions that you don't recognize, you can consult the `list of Cortex M4 instructions <https://developer.arm.com/documentation/ddi0439/b/Programmers-Model/Instruction-set-summary/Cortex-M4-instructions?lang=en>`_
  online, as well as the `list of Floating Point instructions <https://developer.arm.com/documentation/ddi0439/b/Floating-Point-Unit/FPU-Functional-Description/FPU-instruction-set>`_.

Here is an example, taken from the direct form I filter solution of Lab 3. The Assembly code we will analyze is that of the ``iir2`` function.

.. code::

   float32_t iir2(float32_t x,
                  float32_t ntaps[2],
                  float32_t dtaps[2],
                  const float32_t G,
                  const float32_t N[3],
                  const float32_t D[3]) {
       float32_t k1, k2, k3, y;
   
       k1 = N[1] * ntaps[0] + N[2] * ntaps[1];
       k3 = N[0] * x + k1;
   
       k2 = D[1] * dtaps[0] + D[2] * dtaps[1];
       y  = k3 - k2;
   
       ntaps[1] = ntaps[0];
       ntaps[0] = x;
   
       dtaps[1] = dtaps[0];
       dtaps[0] = y;
   
       return y * G;
   }

In the assembly-level analysis, you should be looking to classify each instruction in one of three categories: control, data movement, and computations. It is not required, but it may help, to take apart the meaning of every assembly instruction. This is illustrated in the comments of this listing. Note that the listing was produced using C compilation with no optimization.

.. code::

   iir2:
           SUB       SP, SP, #40           // CONTROL // control
           STR       A4, [SP, #20]         // DATA    // base address D
           STR       A3, [SP, #16]         // DATA    // base address N
           STR       A2, [SP, #8]          // DATA    // base address dtaps
           VSTR.32   S1, [SP, #12]         // DATA    // save S1
           STR       A1, [SP, #4]          // DATA    // base address ntaps
           VSTR.32   S0, [SP, #0]          // DATA    // save S0
   
           ; k1 = N[1] * ntaps[0] + N[2] * ntaps[1];
   
           LDR       A1, [SP, #16]         // DATA    // base address N
           VLDR.32   S0, [A1, #8]          // DATA    // S0 = N[2]
           LDR       A1, [SP, #4]          // DATA    // taps nbase address
           VLDR.32   S1, [A1, #4]          // DATA    // S1 = ntaps[1]
           LDR       A1, [SP, #16]         // DATA    // base address N
           VLDR.32   S2, [A1, #4]          // DATA    // S2 = N[1]
           LDR       A1, [SP, #4]          // DATA    // base address ntaps
           VLDR.32   S3, [A1, #0]          // DATA    // S3 = ntaps[0]
           VMUL.F32  S0, S1, S0            // COMPUTE // N[2] * ntaps[1]
           VMLA.F32  S0, S3, S2            // COMPUTE // + N[1] * ntaps[2]
           VSTR.32   S0, [SP, #24]         // DATA    // save in k1
   
           ; k3 = N[0] * x + k1;
   
           VLDR.32   S1, [SP, #24]         // DATA    // k1
           VLDR.32   S0, [SP, #0]          // DATA    // x
           LDR       A1, [SP, #16]         // DATA    // base address N
           VLDR.32   S2, [A1, #0]          // DATA    // N[0]
           VMLA.F32  S1, S0, S2            // COMPUTE // N[0] * x + k1
           VSTR.32   S1, [SP, #32]         // DATA    // save N[0] * x
   
           ; k2 = D[1] * dtaps[0] + D[2] * dtaps[1];
   
           LDR       A1, [SP, #20]         // DATA    // base address D
           VLDR.32   S0, [A1, #8]          // DATA    // D[2]
           LDR       A1, [SP, #8]          // DATA    // base address dtaps
           VLDR.32   S1, [A1, #4]          // DATA    // dtaps[1]
           LDR       A1, [SP, #20]         // DATA    // base address D
           VLDR.32   S2, [A1, #4]          // DATA    // D[1]
           LDR       A1, [SP, #8]          // DATA    // base address dtaps
           VLDR.32   S3, [A1, #0]          // DATA    // dtaps[0]
           VMUL.F32  S0, S1, S0            // COMPUTE // D[2] * dtaps[1]
           VMLA.F32  S0, S3, S2            // DATA    // + D[1] * dtaps[0] 
           VSTR.32   S0, [SP, #28]         // DATA    // save in k2
   
           ; y = k3 - k2;
   
           VLDR.32   S1, [SP, #32]         // DATA    // k3
           VLDR.32   S0, [SP, #28]         // DATA    // k2
           VSUB.F32  S0, S1, S0            // COMPUTE // k3 - k2
           VSTR.32   S0, [SP, #36]         // DATA    // save in y
   
           ; ntaps[1] = ntaps[0];
   
           LDR       A1, [SP, #4]          // DATA    // base address ntaps
           LDR       A2, [SP, #4]          // DATA    // base address ntaps
           LDR       A1, [A1, #0]          // DATA    // ntaps[0]
           STR       A1, [A2, #4]          // DATA    // save in ntaps[1]
   
           ; ntaps[0] = x;
           LDR       A1, [SP, #0]          // DATA    // x
           LDR       A2, [SP, #4]          // DATA    // base address ntaps
           STR       A1, [A2, #0]          // DATA    // save x in ntaps[0]
   
           ; dtaps[1] = dtaps[0];     
           LDR       A1, [SP, #8]          // DATA    // base address ntaps
           LDR       A2, [SP, #8]          // DATA    // base address ntaps
           LDR       A1, [A1, #0]          // DATA    // ntaps[0]
           STR       A1, [A2, #4]          // DATA    // save in ntaps[1]
   
           ; dtaps[0] = y;       
           LDR       A1, [SP, #36]         // DATA    // y
           LDR       A2, [SP, #8]          // DATA    // base address dtaps
           STR       A1, [A2, #0]          // DATA    // save y in dtaps[0]
   
           ; return y*G
   
           VLDR.32   S0, [SP, #36]         // DATA    // y
           VLDR.32   S1, [SP, #12]         // DATA    // G
           VMUL.F32  S0, S1, S0            // COMPUTE // y*G
           ADD       SP, SP, #40           // CONTROL
           BX        LR                    // CONTROL

After this analysis, you can produce a table with the requested information.
As a reminder, the table that you need to produce, needs to report on the 
processSample function, not just a single iir2.

+-------------------------+----------------------+
| iir2                    |  Non-optimized       |
+=========================+======================+
| Instructions in Binary  |      58              |
+-------------------------+----------------------+
| Exec Ins Data Movement  |         49           |
+-------------------------+----------------------+
| Exec Ins Control        |         3            |
+-------------------------+----------------------+
| Exec Ins Calculations   |         6            |
+-------------------------+----------------------+


.. important::

   Question 2: Analyze the complexity of the ProcessSample function using the methodology
   described above, and for both variants of your implementation: the non-optimized
   variant as well as the optimized variant.
   Please include, in your report, the assembly listings showing your work.

Building the filter using ARM CMSIS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ARM CMSIS library is a library with signal processing functions, optimized for the
ARM platform. In the second half of the lab assignment, you will implement your filter
using the ARM CMSIS library functions.

The coefficients of the filter are identical to the ones you have used for your
design for Question 1 and Question 2; you only have to perform the filtering using
AMR CMSIS function call instead of writing your own code.

A related example can be find in the code for Lecture 7, which demonstrates how
to `program an FIR using ARM CMSIS <https://github.com/wpi-ece4703-b20/dsp_l7/tree/master/dsp_l7_cmsisfir>`_ . Documentation for the `ARM CMSIS Library <https://www.keil.com/pack/doc/CMSIS/DSP/html/index.html>`_ can be found online. The source code of ARM CMSIS is included in the MSP432 SimpleLink Software Development kit, so it's already available on your computer.

The ARM CMSIS library has a specific function to implement a series of biquads. I recommend to look into the `Biquad Implementation Direct Form I <https://www.keil.com/pack/doc/CMSIS/DSP/html/group__BiquadCascadeDF1.html>`_ functions, and in particular to ``arm_biquad_cascade_df1_f32``.

This function takes four arguments. Samples are filtered as a block of ``blockSize`` input samples stored in ``pSrc`` and output sampels returned in ``pDst``. The filter coefficients and the filter state for all biquad sections are stored and configured in the ``S`` data structure.

.. code::

   void arm_biquad_cascade_df1_f32  ( const arm_biquad_casd_df1_inst_f32 *  S,
                                      const float32_t *   pSrc,
                                            float32_t *   pDst,
                                            uint32_t  blockSize 
                                    ) 

The ``arm_biquad_casd_df1_inst_f32`` data structure is a record with several fields, described in their own `documentation page <https://www.keil.com/pack/doc/CMSIS/DSP/html/structarm__biquad__casd__df1__inst__f32.html>`_.

.. code::

  typedef struct
  {
    uint32_t numStages;
    float32_t *pState;
    float32_t *pCoeffs;
  } arm_biquad_casd_df1_inst_f32;


In this structure, ``numStages`` is the number of biquad (second-order) sections, ``pState`` is an
array of ``4 * numStages`` storing filter taps, and ``pCoeffs`` is an array of ``5 * numStages`` storing filter coefficients. The coefficients are stored in the order ``b0, b1, b2, a1, a2``, for each biquad sequentially. Refer to the documentation for a graphical representation of a biquad stage and its relationship to the ``arm_biquad_casd_df1_inst_f32`` structure.

Your design will have to initialize this structure with the coefficients you computed earlier, and then run the filter using a DMA mechanism. DMA is needed because ``arm_biquad_cascade_df1_f32`` needs to work on a block of ``blockSize`` samples at a time, where ``blockSize`` would typically be 8.

The resulting processBuffer call would look like this. It's your job to implement the ``initcascade`` function that initializes the arm_biquad_casd_df1_inst_f32 with filter coefficients.

.. code::

   void processBuffer(uint16_t x[BUFLEN_SZ], uint16_t y[BUFLEN_SZ]) {
       adc14_to_f32_vec(x, xf, BUFLEN_SZ);
       arm_biquad_cascade_df1_f32(&S, xf, yf, BUFLEN_SZ);
       f32_to_dac14_vec(yf, y, BUFLEN_SZ);
   }
   
   #include <stdio.h>
   
   int main(void) {
       WDT_A_hold(WDT_A_BASE);
   
       initcascade(&S);
       msp432_boostxl_init_dma(FS_32000_HZ, BOOSTXL_J1_2_IN, BUFLEN, processBuffer);
   
       uint32_t c = measurePerfBuffer(processBuffer);
       printf("Cycles %d\n", c);
   
       msp432_boostxl_run();
   
       return 1;
   }


After you have completed the code, and verified that it works, you will do a performance analysis similar to Question 1. In particular, you will compile two versions of your code, a non-optimized one and an optimized one. You do not have to analyze the resulting assembly code; performance analysis is sufficient.

Variant 1: Unoptimized Code
"""""""""""""""""""""""""""

1. Configure the compiler to disable all optimization *(Project Properties - CCS Build - 
   ARM Compiler - Optimization - Optimization Level Off)*. Compile the code.

2. Run the code on your board and determine the sample rate achieved by the code by measuring the 
   sample frequency on the duty cycle pin (P5.7 on your MSP432 kit). In a DMA mechanism,
   the duty cycle pin is set high when processing PING buffers, and it is set low when processing
   PONG buffers. You should observe a regular square wave.

3. Determine the clock cycle count needed to execute the processBuffer function.

Variant 2: Optimized Code
"""""""""""""""""""""""""""

1.  Configure the compiler to compiler for speed and function inlining
   *(Project Properties - CCS Build - ARM Compiler - Optimization - 
   Interprocedure Optimizations - Optimize for Speed)*. Compile the code.

2. Run the code on your board and determine the sample rate achieved by the code by measuring the 
   sample frequency on the duty cycle pin (P5.7 on your MSP432 kit). In a DMA mechanism,
   the duty cycle pin is set high when processing PING buffers, and it is set low when processing
   PONG buffers. You should observe a regular square wave.

3. Determine the clock cycle count needed to execute the processBuffer function.

.. important::

   Question 3: Report on the cycle count observed for each case (unoptimized and optimized), 
   and report on the observed block frequency produced by the duty cycle pin. Please make sure that 
   your filter is operational, and that it is using the correct filter coefficients. 
   An easy (but optional) way demonstrate this, is to show a plot of  the filter spectrum, 
   as obtained using Bitscope.

Wrapping Up
^^^^^^^^^^^

* The answer to this lab consists of a written report which will be submitted on Canvas by the deadline. Refer to the General Lab Report Guidelines for details on report formatting. You will only submit your written report on Canvas. All code developed must be returned through GitHub.

* Follow the principal structure of the report you've used for Lab 4 (taking into account any feedback you have received).

* Follow the four questions outlined above to structure your report.  Use figures, screenshots and code examples where appropriate. Please work out the answers in sufficient detail to show your *analysis*.

* Make sure that you add newly developed projects to github: Use the Team - Share pop-up menu and select your repository for this lab. Further, make sure that you commit and push all changes to the github repository on GitHub classroom. Use the Team - Commit pop-up menu and push all changes.

* Be aware that each of the laboratory assignments in ECE4703 will require a significant investment in time and preparation if you expect to have a working system by the assignment’s due date. This course is run in “open lab” mode where it is not expected that you will be able to complete the laboratory in the scheduled official lab time. It is in your best interest to plan ahead so that you can use the TA and instructor’s office hours most efficiently.

*Good Luck*

Grading Rubric
^^^^^^^^^^^^^^

+---------------------------------------------------------+------------+
| Requirement                                             |   Points   |
+=========================================================+============+
| Question 1 Analysis                                     |    20      |
+---------------------------------------------------------+------------+
| Question 2 Analysis                                     |    30      |
+---------------------------------------------------------+------------+
| Question 3 Analysis                                     |    25      |
+---------------------------------------------------------+------------+
| All projects build without errors or warnings           |     5      |
+---------------------------------------------------------+------------+
| Code is well structured and commented                   |     5      |
+---------------------------------------------------------+------------+
| Git Repository is complete and up to date               |     5      |
+---------------------------------------------------------+------------+
| Overall Report Quality (Format, Outline, Grammar)       |    10      |
+---------------------------------------------------------+------------+
| **TOTAL**                                               | **100**    |
+---------------------------------------------------------+------------+
