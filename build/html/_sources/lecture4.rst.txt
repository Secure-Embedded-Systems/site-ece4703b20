.. ECE 4703 

L4: FIR filter implementation
=============================

The purpose of this lecture is as follows.

* To describe the direct-form and transpose-form implementations of FIR designs
* To describe the cascade-form implementations of FIR designs
* To describe frequency-sampling implementations of FIR designs
* To describe memory management optimization in FIR implementation

Direct-form and Transpose-form FIR implementation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Let's recap the standard, direct-form representation of an FIR filter as discussed last
lecture.

The Z-transform of an FIR is a polynomial in :math:`z^{-1}`.

.. math::

  H(z) = \sum_{n=0}^{N} h(n) . z^{-n}

The sequence :math:`h(n)` is the *impulse response* of the FIR filter. This sequence is bounded.

The classic **direct-form implementation** of an FIR filter is done by implementing a *tapped delay line*.
The following is an example of a third-order FIR filter. Such a filter would have three zeroes in the z-plane 
and three poles at :math:`z=0`.
It has 4 multiplications with coefficients, 3 additions, and three delays.

.. figure:: images/firdirect.jpg
   :figwidth: 600px
   :align: center

Interestingly, the impulse response of the FIR can be produced by an alternate structure, called the
**transpose-form implementation**. Unlike the direct-form implementation, the
transpose-form implementation multiplies an input sample with all filter coefficients at
the same time, and then accumulates the result. Note that the order of the impulse
response coefficients is reversed.

.. figure:: images/transposefir.jpg
   :figwidth: 600px
   :align: center


Optimizing for Symmetry (Linear Phase FIR)
""""""""""""""""""""""""""""""""""""""""""

We already know that the time-domain shape of a signal is determined by both the phase information 
as well as the amplitude information of its frequency components. If phases are randomly
changed, then the time-domain shape will be distored. 

Think, for example, about how we are measuring the spectrum of a filter, by injection random noise at the input. Random noise contains all frequencies, just like a Dirac impulse. But unlike a Dirac impulse, random noise has random phase. Therefore, we have a time domain response spread out over time, rather than a single, sharp impulse.

Many applications in communications (digital modulation, software radio, etc) rely on precise
time-domain representation of signals; we will discuss such an application in a later lecture
of the course. In digital communications applications, filters with a **linear phase response** are desired,
because such filters introduce a uniform delay as a function of frequency.  In other words: a signal that
fits within the passband of a linear phase filter, will appear undistorted at the output
of the filter.

Indeed, assume that the phase response is of the form :math:`\phi(\omega) = k_1 . \omega + k_0`. 
A sinusoid :math:`sin(\omega.t)` that is affected by this phase change, becomes:

.. math::

   y(t) =& sin(\omega.t + k_1 . \omega + k_0) \\
        =& sin(\omega.(t + k1) + k_0)

Thus, a linear phase response causes a time-shift of the sinusoid, independent of its frequency. This means
that an arbitrarily complex signal, which can be written as a sum of phasors (sines/cosines), will also be
affected by a time-shift, independent of its frequency.

Linear phase filters have a symmetric impulse response, and there are four types of symmetry, depending
on the odd/even number of taps, and the odd/even symmetry of the impulse response. All of these filters
have a linear phase response. 

.. figure:: images/linearphasefir.jpg
   :figwidth: 600px
   :align: center


The symmetric response of linear FIR design enables an important optimization for either
direct-form or else transpose form FIR designs: we can reduce the number of coefficient
multiplications by half. For example, here is an optimized Type-III, 3-tap FIR:

.. figure:: images/firdirectfolded.jpg
   :figwidth: 600px
   :align: center


Optimizing Common Subexpressions
""""""""""""""""""""""""""""""""

The transpose form is convenient when the implementation is able to perform parallel multiplications
efficiently, or when parallel multiplications can be jointly optimized. 

For example, the following filter coefficient optimization is common in hardware designs of fixed-coefficient FIRs.  The transpose form can be optimized for common subexpressions. Since the same input x is
multiplied with every filter coefficient at the same time, the common parts of the multiplication
can be shared. Consider the impulse response :math:`h(n) = {3, 5, 5, 3}`. This series
of coefficients is symmetric, meaning that only a single multiplication with 3 and with 5 is needed.
In addition, the multiplications with 3 and with 5 share commonalities. Since 3 = 1 + 2 and 5 = 1 + 4,
we can implement these multiplications using constant shifts by 2, and then accumulating the results:

.. figure:: images/transposefir3553.jpg
   :figwidth: 600px
   :align: center

In other words, we can rewrite the following set of expressions:

.. code:: c
   :number-lines: 1

   // input x
   // state_variable: d2, d1, d0
   // output y
   y  = d2 + x * 3;
   d2 = d1 + x * 5;
   d1 = d0 + x * 5;
   d0 =      x * 3;


into the following set of expressions - avoiding multiplications. This would be especially advantageous
in a hardware design, because it significantly reduces the implementation cost. In software, where the
cost of a  '*' operation and a '+' operation are similar, such optimization may have less (or no) impact.

.. code:: c
   :number-lines: 1

   // input x
   // temporary variable x2, x4, s3, s5;
   // state_variable: d2, d1, d0
   // output y
   x2 = x  << 1;
   x4 = x2 << 1;
   s3 = x  +  x2;
   s5 = x  +  x4;
   y  = d2 +  s3;
   d2 = d1 +  s5;
   d1 = d0 +  s5;
   d0 =       s3;

Cascade-form FIR implementation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A polynomial expression in H(z) can be factored into sub-expressions of first-order factors as follows.

.. math::

   H(z) = \sum_{n=0}^{N} h(n) . z^{-n} = A \prod_{k=1}^{N}(1 - a_k.z^{-1})

In the decomposed form, the first-order terms represent the zeroes for H(z). If h(n) is real, then the roots of H(z) will come in complex conjugate pairs, which can be combined into second-order expressions with real coefficients. Such real coefficients are preferable, of course, because they can be directly implemented using a single multiply operation.

.. figure:: images/cascade.jpg
   :figwidth: 600px
   :align: center


Example - Cascade Design for the Averager
"""""""""""""""""""""""""""""""""""""""""

Consider the moving average filter we discussed last lecture.

.. math::

   G(z) = z^{-1} + z^{-2} + z^{-3} + z^{-4} + z^{-5} + z^{-6} + z^{-7} + z^{-8}

This filter has seven zeroes, regularly distributed around the unit circle
with the exception of the location z=1.

.. figure:: images/zplaneconjugate.jpg
   :figwidth: 300px
   :align: center

We can identify three complex conjugate zero pairs, which can be written as second-order sections.
If a complex conjugate pair has zeroes at locations :math:`A.e^{\pm j \phi}`, then the second-order
location can be written as follows.

.. math::

  V(z) =& (1 - A.e^{+ j \phi}.z^{-1}) . (1 - A.e^{- j \phi}.z^{-1}) \\
  V(z) =& 1 - 2.A.cos(\phi).z^{-1} + A^2.z^{-2}

The complex conjugate pairs are located at :math:`e^{\pm j \pi /4}`, :math:`e^{\pm j \pi /2}`, :math:`e^{\pm j 3 \pi /4}`, which leads to the following second order stages:

.. math::

  V1(z) &= 1 + z^{-2} \\
  V2(z) &= 1 + \sqrt{2}.z^{-1} + z^{-2} \\
  V3(z) &= 1 - \sqrt{2}.z^{-1} + z^{-2}

Putting everything together, we then obtain the following cascade filter. Note that this design
has added an extra delay at the input, as well as an extra zero (at :math:`z=-1`).

.. figure:: images/cascadeexample.jpg
   :figwidth: 600px
   :align: center

Example - C code for the Averager Cascade Design 
""""""""""""""""""""""""""""""""""""""""""""""""

.. note::

   This example is available in the dsp_l4 repository as dsp_l4_cascade.

We will now implement this filter in C code.
Since the cascade form is repetitive, it makes sense to implement it as a separate function. 
It's worthwhile to consider the regularity of this problem. The filter, in 
essence, can be captured in four cascade filters. Therefore, we will write C code for a single
cascade filter, and replicate it in order to create the overall filter.

Let's start with the single cascade stage. The ``casecadestate_t`` is a data type that
stores the cascade filter taps as well as the coefficients. Since we are creating
a repetition of filters, we have to keep the state as well as the coefficients of the individual
stages separate, and this record helps us do that. Next, the ``cascadefir`` computes
the response on a single casecade stage. The function evaluates the output, and updates
the state as the result of entering a fresh sample x. Finally, the ``createcascade``
function is a helper function to initialize the coefficients in a ``casecadestate_t`` type.

.. code:: c
   :number-lines: 1

   typedef struct cascadestate {
       float32_t s[2];  // filter state
       float32_t c[2];  // filter coefficients
   } cascadestate_t;
   
   float32_t cascadefir(float32_t x, cascadestate_t *p) {
       float32_t r = x + (p->s[0] * p->c[0]) +  (p->s[1] * p->c[1]);
       p->s[1] = p->s[0];
       p->s[0] = x;
       return r;
   }
   
   void createcascade(float32_t c0,
                      float32_t c1,
                      cascadestate_t *p) {
       p->c[0] = c0;
       p->c[1] = c1;
       p->s[0] = p->s[1] = 0.0f;
   }

We are now ready to build the overall filter. This will break down into two functions, the first one to initialize the individual cascade states according to the filter specifications, and the second one to execute the processing of a single sample. The four cascade filters are created as global variables, so that they are easy to access from withing the ADC interrupt callback. The `initcascade` function defines the coefficients as defined earlier. The ``M_SQRT2`` macro is a pre-defined macro in the C math library that holds the square root of 2. The ``processCascade`` function computes the output of the input. The overall
filter includes an extra delay (to implement :math:`G(z) = z^{-1} + z^{-2} + z^{-3} + z^{-4} + z^{-5} + z^{-6} + z^{-7} + z^{-8}`), which is captured with the local ``static`` variable d.

.. code:: c
   :number-lines: 1

   cascadestate_t stage1;
   cascadestate_t stage2;
   cascadestate_t stage3;
   cascadestate_t stage4;
   
   void initcascade() {
       createcascade(    0.0f,  1.0f, &stage1);
       createcascade( M_SQRT2,  1.0f, &stage2);
       createcascade(-M_SQRT2,  1.0f, &stage3);
       createcascade(    1.0f,  0.0f, &stage4);
   }
   
   uint16_t processCascade(uint16_t x) {
   
       float32_t input = adc14_to_f32(0x1800 + rand() % 0x1000);
       float32_t v;
       static float32_t d;
   
       v = cascadefir(d, &stage1);
       v = cascadefir(v, &stage2);
       v = cascadefir(v, &stage3);
       v = cascadefir(v, &stage4);
       d = input;
   
       return f32_to_dac14(v*0.125);
   }

If we run the function and compute the output, we can find that this design has an
identical response as the previous direct-form design.

The appeal of the cascade form FIR is the regularity of the design, as well as (as discussed
later), a better control over the precision and range of intermediate variables.


Frequency-sampling FIR
^^^^^^^^^^^^^^^^^^^^^^

A fourth form of FIR structure, next to direct-form, transpose-form and cascade-form design, is that of frequency sampling. Interestingly, the frequency-sampling structure is a recursive structure, despite
the fact that its impulse response is finite in length.

A basic building block of a frequency-sampling FIR is a *resonator*, a structure with a
complex conjugate pole-pair on the unit circle, together with a double zero in the unit circle origin.

.. math::

   H(z) =& \frac{z^2}{z^2 - 2.z.cos(\theta) + 1}        \\
        =& \frac{1}{1 - 2.z^{-1}.cos(\theta) + z^{-2}}  \\
        =& \frac{Y(z)}{X(z)}

The time-domain response of this design is given by

.. math::

  y(n) = 2.cos(\theta).y(n-1) - y(n-2) + x(n)

For example, if :math:`\theta = \pi / 3` then the time-domain response is given by

.. math::

  y(n) = y(n-1) - y(n-2) + x(n)

The resonator by itself is not a useful filter.
This structure is not stable, and after a single impulse response it keeps oscillating.

+---------------+-------------+--------------+---------------+
|  x(n)         |   y(n-2)    |   y(n-1)     |   y(n)        |
+===============+=============+==============+===============+
|   0           |    0        |    0         |     0         |
+---------------+-------------+--------------+---------------+
|   1           |    0        |    0         |     1         |
+---------------+-------------+--------------+---------------+
|   0           |    0        |    1         |     1         |
+---------------+-------------+--------------+---------------+
|   0           |    1        |    1         |     0         |
+---------------+-------------+--------------+---------------+
|   0           |    1        |    0         |     -1        |
+---------------+-------------+--------------+---------------+
|   0           |    0        |    -1        |     -1        |
+---------------+-------------+--------------+---------------+
|   0           |    -1       |    -1        |     0         |
+---------------+-------------+--------------+---------------+
|   0           |    -1       |    0         |     1         |
+---------------+-------------+--------------+---------------+
|   0           |    0        |    1         |     1         |
+---------------+-------------+--------------+---------------+
|   0           |    etc      |    etc       |    etc        |
+---------------+-------------+--------------+---------------+

However, when the resonator is combined with a comb filter structure, which
we discussed last week, we obtain a **frequency-sampling filter**. 
A comb filter with `m` teeth is a FIR of the form

.. math::

  G(z) = 1 - z^m

If a resonator is driven by the output of a comb filter, then the unstable characteristic
of the resonator is cancelled by a matching zero of the comb filter.
For example, let's consider a comb filter with 24 teeth, i.e., a filter with zeroes
on the unit circle at every :math:`\pi / 12`.


.. figure:: images/frequencysampling.jpg
   :figwidth: 600px
   :align: center


This can be extended to an arbitrary response by adding additional resonator stages.
The general design of a **Frequency Sampling Filter** then consists of (1) setting 
up a frequency grid as a comb filter, and (2) strategically eliminating zeroes using 
resonator stages in order to create
the desired response. The design is fairly rudimentary, as we cannot select the gain
of the filter at a particular frequency - we can only let a frequency pass or eliminate it.
Furthermore, we can only constrain the response at a specific number of points, corresponding
to the locations of zeroes defined by the comb filter.

On the other hand, compared to a pure feedforward FIR design, the frequency sampling
filter is more economical, and can be realized using fewer taps.


.. note::

   This example is available in the dsp_l4 repository as dsp_l4_fsampling.


Memory Management in FIR
^^^^^^^^^^^^^^^^^^^^^^^^^

FIR designs can become relatively complex, up to a few hundred taps with coefficients. 
Hence, at some point the  implementation of the FIR delay line becomes an important factor in 
the filter performance.

.. note::

   This example is available in the dsp_l4 repository as dsp_l4_longfilters.

In a straightforward design, the filter taps are shifted every sample. For an N-tap
filter, this means N memory reads and N memory writes. Furthermore, for each
memory access, the memory address for the tap has to be computed.

.. code:: c
   :number-lines: 1

   uint16_t processSampleDirectFull(uint16_t x) {
       float32_t input = adc14_to_f32(x);
   
       taps[0] = input;
   
       float32_t q = 0.0;
       uint16_t i;
       for (i = 0; i<NUMTAPS; i++)
           q += taps[i] * B[i];
   
       for (i = NUMTAPS-1; i>0; i--)
           taps[i] = taps[i-1];
   
       return f32_to_dac14(q);
   }

Complexity Analysis
"""""""""""""""""""

To understand the complexity of this function, we can study the assembly code (found under ``Debug/main.lst`` in Code Composer Studio). We can clearly distinguish the loops by looking for the jump instructions and the jump target labels. The register names starting with ``V`` carry floating-point variables. It's remarkable that the computational core of this algorithm, the expression ``q += taps[i] * B[i]`` in the C program,
is captured by a single instruction ``VMLA`` (floating-point multiply accumulate). 

.. code:: 
   :number-lines: 1

   processSampleDirectFull:
           PUSH      {A4, V3, V4, LR}     
           BL        adc14_to_f32         
           VMOV.F32  S1, S0               
           LDR       A1, $C$FL4           
           LDR       A3, $C$CON15         
           LDR       A2, $C$CON14         
           VMOV      S0, A1               
           LDRH      V3, [A3, #0]         
           VSTR.32   S1, [A2, #0]         
           CBZ       V3, ||$C$L5||        
           LDR       A1, $C$CON17         
           MOV       V4, V3               
           MOV       A3, A2               
   ||$C$L4||:                                ;
           LDR       A4, [A3], #4            ;
           VMOV      S1, A4                  ; 
           LDR       A4, [A1], #4            ; for (i = 0; i<NUMTAPS; i++)
           VMOV      S2, A4                  ;   q += taps[i] * B[i];
           SUBS      V4, V4, #1              ;
           VMLA.F32  S0, S2, S1              ;
           BNE       ||$C$L4||               ;
           SUBS      V3, V3, #1           
           UXTH      A1, V3               
           CBZ       A1, ||$C$L7||        
           ADD       A2, A2, A1, LSL #2   
   ||$C$L6||:                                ;
           VLDR.32   S1, [A2, #-4]           ;
           SUBS      A1, A1, #1              ;
           VMOV      A3, S1                  ; for (i = NUMTAPS-1; i>0; i--)
           UXTH      A1, A1                  ;   taps[i] = taps[i-1];
           CMP       A1, #0                  ;
           STR       A3, [A2], #-4           ;
           BNE       ||$C$L6||               ;
   ||$C$L7||:    
           BL        f32_to_dac14         
           POP       {A4, V3, V4, PC}      


.. important::

   The previous listing is an example of ARM assembly code. While I do not expect you to memorize
   the exact ARM mnemonics, it will be helpful (and interesting) to become used to the based
   form and format of assembly listings. 
   A list of ARM Cortex-M4 instructions can be found on the `ARM Developer Pages <https://developer.arm.com/documentation/ddi0439/b/Programmers-Model/Instruction-set-summary/Cortex-M4-instructions>`_.


   A line such as 

   .. code::

      ||$C$L6||:  

   is a label; it represents the target address of the instruction just after the label.
   You can use labels and match them with jump instructions to establish the beginning
   and ending of a loop. The jump instruction matching ``||$C$6||`` is BNE:

   .. code::

      ||$C$L6||:  
           ...
           BNE       ||$C$L6||

   ARM instructions are in the format <instruction, destination, source>. For example, the
   following instruction means `move register A4 to register S2`. 

   .. code::

      VMOV      S2, A4

   Memory operations include LDR (load register) and
   STR (store register). Memory operations specify a memory address, and ARM supports a
   range of addressing modes to specify the address. For example, the following instruction
   stores the contents of register A3 in the memory location pointed by register A2. Afterwards,
   modify register A2 by subtracting 4. 

   .. code::

      STR       A3, [A2], #-4

   As another example, the following instruction stores S1 to the memory address pointed to 
   by A2 minus 4.

   .. code::

      VLDR.32   S1, [A2, #-4]


Studying the assembly helps us to appreciate the overhead of data movement. First, note that the loop body of the filter delay-line shift (loop ``||$C$L6||``) contains 7 instructions, while the loop body of the filter multiply-accumulate (loop ``||$C$L4||``) contains 7 instructions as well! In addition, the delay-line shift contains a memory-read (``VLDR.32``) as well as a memory-write (``STR``), while the multiply-accumulate loop contains two memory-read (``LDR``). 


Optimization
""""""""""""

A common optimization of delay lines is the use of a `circular buffer`. To see how to use a circular buffer on a FIR, let's first consider the memory-access operations for a regular FIR.
Each sample period, a new sample enters the filter state. The filter state is then multiplied with the coefficients to compute the filter output, and finally, the filter state is shifted in order to accept the next sample. New samples are entered at a fixed location in the filter state.

.. figure:: images/firmemory.jpg
   :figwidth: 400px
   :align: center

In a circular buffer strategy, we avoid shifting the filter state, but rather change the position where new samples are inserted. New samples will overwrite the oldest sample in the filter state, so that each sample period, the 'head' of the filter shifts backward in the array. When the beginning of the array is reached, the head jumps to the back. In this configuration, the 'first' tap in the filter state is continuously shifting, and therefore the filter coefficients have to be rotated accordingly. However, this rotation operation is easier to implement than shifting: because the coefficients do not change, the rotation operation can be implemented using index operations.


.. figure:: images/firmemoryrot.jpg
   :figwidth: 400px
   :align: center

This leads to the following FIR design. Observe that the tap-shift loop has disappeared, while the address expressions have become more complicated. A new ``head`` variable is used to indicated the first tap in the filter state. This ``head`` circulates to all positions of the delay line until it wraps around.

.. code:: c
   :number-lines: 1

   uint16_t processSampleDirectFullCircular64(uint16_t x) {
       float32_t input = adc14_to_f32(x);
   
       taps[(64 - head) % 64] = input;
   
       float32_t q = 0.0;
       uint16_t i;
       for (i = 0; i<64; i++)
           q += taps[i] * B[(i + head) % 64];
   
       head = (head + 1) % 64;
   
       return f32_to_dac14(q);
   }


The assembly code for this implementation now shows that there are 9 operations in the inner multiply-accumulate loop. Note that modulo addressing with an arbitrary modulo is still an
expensive operation (integer division). By keeping the delay line length at a power of two, the modulo operations are however economical (bitwise AND, as demonstrated in the assembly code).


.. code:: 
   :number-lines: 1

   processSampleDirectFullCircular64:
           PUSH      {A4, V1, V2, V3, V4, LR} 
           BL        adc14_to_f32             
           MOVS      V4, #64                  
           LDR       A3, $C$CON1              
           LDR       V2, $C$FL1               
           LDR       V3, $C$CON2              
           LDRH      A1, [A3, #0]             
           LDR       V1, $C$CON3              
           VMOV      V9, S0                   
           RSB       A2, A1, #64              
           VMOV      S0, V2                   
           ASRS      A4, A2, #5               
           ADD       A4, A2, A4, LSR #26      
           BIC       A4, A4, #63              
           SUBS      A2, A2, A4               
           LSLS      A4, A1, #2               
           STR       V9, [V3, +A2, LSL #2]    
   ||$C$L1||:       
           LDR       V2, [V3], #4             
           AND       A2, A4, #252             
           SUBS      V4, V4, #1               
           VMOV      S1, V2                   
           ADD       A2, V1, A2               
           VLDR.32   S2, [A2, #0]             
           ADD       A4, A4, #4               
           VMLA.F32  S0, S2, S1               
           BNE       ||$C$L1||                
           ADDS      A1, A1, #1               
           AND       A1, A1, #63              
           STRH      A1, [A3, #0]             
           BL        f32_to_dac14             
           POP       {A4, V1, V2, V3, V4, PC} 

Finally, using profiling, we compare the cycle cost of the original FIR design (with shifting) and the optimized FIR design (with a circular buffer). This shows a gain of 


+------------------------+--------------------+-----------------+--------------------+
|  FIR Design            | 16 taps            | 32 taps         | 64 taps            |
+========================+====================+=================+====================+
| tap-shift              |      383           |    703          |    1343            |
+------------------------+--------------------+-----------------+--------------------+
| circular buffer        |      306           |    530          |   913              |
+------------------------+--------------------+-----------------+--------------------+
| throughput (circular)  |      1.25x         |    1.32x        |   1.47x            |
+------------------------+--------------------+-----------------+--------------------+

Conclusions
^^^^^^^^^^^

We reviewed four different implementation styles for FIR filters: direct-form, transpose-form, cascade-form and frequency-sampling filter. The first three are able to implement any filter for which you can specific an finite impulse response. The frequency-sampling filter is a specific design technique that combines filter
design and filter implementation.

Next, we also reviewed the impact of memory organization on FIR design. Memory operations are expensive, and the streaming nature of DSP tends to generate lots of memory accesses. FIR designs can be implemented using a circular buffer. The basic idea in memory optimization is to reduce data movement as much as possible, at the expense of more complex memory adderssing.

We have not discussed the design of FIR filters; a tool such as Matlab filterDesigners helps you compute filter coefficients, quantize filter coefficients, and compute amplitude/phase response. Please refer to Lab 2.

*If time left: discuss Matlab filterDesigner*