.. ECE 4703 

Midterm Questions
=================

.. _program1:

Program 1
^^^^^^^^^

.. code::

   #include <ti/devices/msp432p4xx/driverlib/driverlib.h>
   #include "msp432_boostxl_init.h"
   
   uint16_t lookup[12] = {0x2000, 0x2000, 0x2000, 0x2000, 
                          0x3000, 0x3000, 0x3000, 0x3000, 
                          0x2000, 0x2000, 0x2000, 0x2000};
   static int ptr = 0;
   
   uint16_t processSample(uint16_t x) {
       ptr = (ptr + 1) % 12;
       return lookup[ptr];
   }
   
   #include <stdio.h>
   
   int main(void) {
       WDT_A_hold(WDT_A_BASE);
   
       msp432_boostxl_init_intr(FS_32000_HZ, BOOSTXL_J1_2_IN, processSample);
       msp432_boostxl_run();
   
       return 1;
   }


.. _figure1:

Figure 1
^^^^^^^^

.. figure:: images/midb20q2.jpg
   :figwidth: 600px
   :align: center

**Option A**

.. math::

   H(z) = \frac{1 - z^{-1}/2 + z^{-2}/4}{1 - z^{-1}/(2 \sqrt 2)}


**Option B** 

.. math::

    H(z) = \frac{1 - z^{-2}/16}{1 - z^{-1}/2 + z^{-2}/4}


**Option C** 

.. math::

   H(z) = \frac{1 + z^{-1}/(2 \sqrt 2) + z^{-2}/16}{1 - z^{-1}/2 + z^{-2}/4}


**Option D** 

.. math::

   H(z) = \frac{1 + z^{-1}/(2 \sqrt 2) + z^{-2}/16}{1 - z^{-1}/2}

**Option E** 

.. math::

   H(z) = \frac{1 + z^{-1}/(2 \sqrt 2)}{1 - z^{-1}/2 - z^{-2}/4}

.. _figure2:

Figure 2
^^^^^^^^

.. figure:: images/midb20q4.jpg
   :figwidth: 600px
   :align: center

Figure 3
^^^^^^^^

**G1(z)**

.. math::

   G1(z) = \frac{1}{1 - 0.5.z^{-1}}


**G2(z)**

.. math::

   G2(z) = \frac{1}{1 + 0.5.z^{-1}}

**G3(z)**

.. math::

   G3(z) = {1 - 0.5.z^{-1}}

**G4(z)**

.. math::

   G4(z) = {1 + 0.5.z^{-1}}

.. _program2:

Program 2
^^^^^^^^^

.. code::

   #include <ti/devices/msp432p4xx/driverlib/driverlib.h>
   #include "msp432_boostxl_init.h"
   #include "msp432_arm_dsp.h"
   
   uint16_t processSample(uint16_t x) {
      float32_t tap[3];
   
      float32_t input = adc14_to_f32(x);
   
      tap[2] = tap[1];
      tap[1] = tap[0];
      tap[0] = x;
   
      return f32_to_dac14((tap[0] + tap[1] + tap[2])/3.0);
   }
   
   #include <stdio.h>
   
   int main(void) {
       WDT_A_hold(WDT_A_BASE);
   
       msp432_boostxl_init_intr(FS_32000_HZ, BOOSTXL_J1_2_IN, processSample);
       msp432_boostxl_run();
   
       return 1;
   }

.. _program3:

Program 3
^^^^^^^^^

.. code::

   float32_t taps[16];
   float32_t coeff[16] = {0.25, 0.0, 0.0, 0.0,
                          0.25, 0.0, 0.0, 0.0,
                          0.25, 0.0, 0.0, 0.0,
                          0.25, 0.0, 0.0, 0.0};
   
   uint16_t processSample(uint16_t x) {
       float32_t input = adc14_to_f32(x);
   
       taps[0] = input;
   
       float32_t q = 0.0;
       uint16_t i;
       for (i = 0; i<16; i++)
           q += taps[i] * coef[i];
   
       for (i = 16-1; i>0; i--)
           taps[i] = taps[i-1];
   
       return f32_to_dac14(q);
   }
