.. ECE 4703 

Technical Documentation
=======================

On this page you find pointers to relevant hardware and software documentation, downloads, and online references.
In summary, you will need the following hardware and software to complete the assignments of this course.

* Software

  * `Code Composer Studio v10 <https://hub.wpi.edu/software/576/code-composer-studio>`_ 
  * `MSP432 Software Development Kit <https://www.ti.com/tool/download/SIMPLELINK-MSP432-SDK>`_
  * `Matlab R2020 <https://hub.wpi.edu/software/482/matlab>`_ 
  * A `GitHub <https://github.com/>`_ account 
  * A git client such as `Turtoise GIT <https://tortoisegit.org/>`_

* Hardware

  * `MSP-EXP432P401R Launchpad <https://www.ti.com/tool/MSP-EXP432P401R>`_: Development board with 48 MHz ARM Cortex M4.
  * `Audio Signal Processing Boosterpack <https://www.ti.com/tool/BOOSTXL-AUDIO>`_: Audio Extension board for MSP-EXP432.
  * A USB Oscilloscope such as `Bitscope BS05 <http://bitscope.com/product/BS05/>`_ or `Analog Discovery 2 <https://store.digilentinc.com/analog-discovery-2-100msps-usb-oscilloscope-logic-analyzer-and-variable-power-supply/>`_.

DSP Books
^^^^^^^^^

The official course textbook is `Digital Signal Processing Using the ARM Cortex-M4 <https://www.wiley.com/en-us/Digital+Signal+Processing+Using+the+ARM+Cortex+M4-p-9781118859049>`_. We will follow the overall outline of this book but will not literally depend on it. Hence, don't feel compelled to buy the book as there will be ample documentation and supporting materials available for free.

Here are several other good references on Digital Signal Processing. All of the following works focus on Digital Signal Processing, and not on writing DSP programs.

* `Digital Signal Processing, 4th Edition <https://www.pearson.com/us/higher-education/program/Proakis-Digital-Signal-Processing-4th-Edition/PGM258227.html>`_ by John G. Proakis and Dimitris K Manolakis is a standard text on DSP (and the book you're familiar with from ECE 2312).
* `An Introduction to the Analysis and Processing of Signals <https://link.springer.com/book/10.1007/978-1-349-19719-4>`_ by Paul Lynn is a brilliant summary text on digital signal processing. It's pretty old, but it does a wonderful job at explaining the fundamentals without loosing itself in math.
* `Schaums Outline Of Digital Signal Processing, 2nd Edition <https://www.mhprofessional.com/9780071635097-usa-schaums-outline-of-digital-signal-processing-2nd-edition>`_ discusses the essentials of Digital Signal Processing Theory. 

.. comment:
   * `Discrete-Time Signal Processing <https://www.pearson.com/us/higher-education/program/Oppenheim-Discrete-Time-Signal-Processing-3rd-Edition/PGM212808.html>`_ by Oppenheim and Schafer is the Cadillac under the DSP textbooks. It's a classic and a must have if you're gonna make a career out of (digital) signal processing. This level of quality comes at a cost, however.

Code Composer Studio
^^^^^^^^^^^^^^^^^^^^

  * `CCS Documentation Tree <http://software-dl.ti.com/ccs/esd/documents/ccs_documentation-overview.html>`_ 
  * `ARM Assembly Language Tools <http://downloads.ti.com/docs/esd/SPNU118/>`_ 
  * `ARM Optimizing C/C++ Compiler User Guide <http://downloads.ti.com/docs/esd/SPNU151/>`_ 

Matlab
^^^^^^

  * `DSP System Toolbox <https://www.mathworks.com/help/dsp/index.html>`_

.. _hardware_manuals:

MSP-EXP432P401R Kit
^^^^^^^^^^^^^^^^^^^

  * `MSP-EXP432P401R Development Kit User's Guide <https://www.ti.com/lit/pdf/slau597>`_
  * `MSP432P401R Driver Library User's Guide <http://dev.ti.com/tirex/explore/node?node=AJIAWhC7vhw.P.ggQJeRmw__z-lQYNj__LATEST>`_
  * `MSP432P4xx Technical Reference Manual <https://www.ti.com/lit/ug/slau356i/slau356i.pdf>`_
  * `MSP432P401R Data Sheet <https://www.ti.com/lit/ds/symlink/msp432p401r.pdf>`_
  * `BOOSTXL-AUDIO User's Guide <https://www.ti.com/lit/pdf/slau670>`_


.. _bitscope:

Bitscope BS05
^^^^^^^^^^^^^

  * `Summary of features <https://www.bitscope.com/product/BS05/>`_
  * `Operating Manual <https://docs.bitscope.com/KLTUKBXN/>`_
  * `Software Download <http://my.bitscope.com/download/>`_

You need to install the **Bitscope DSO software package** for this course. 
The other software packages are optional.

If you cannot go to the lab in the ECE Department to use the bench equipment, you will need a USB oscilloscope. The minimum requirements are relaxed, but make sure you have at least 10MHz input bandwith (20 Msamples/second) and two channels. Many USB scopes come with software that supports signal analysis functions such as computing the frequency spectrum. If your USB scope does not provide such software support, make sure that you can export data to Matlab (where you can compute the FFT).

Here are a few other examples of suitable USB oscilloscopes.

* `Analog Discovery 2 <https://store.digilentinc.com/analog-discovery-2-100msps-usb-oscilloscope-logic-analyzer-and-variable-power-supply/>`_ is a 100Ms/s USB scope with logic analyzer ($279). The device is currently on back-order - unless you already have it, you may look for model with better accessibility.

* `Picoscope 2000 <https://www.picotech.com/oscilloscope/2000/picoscope-2000-overview>`_ is a basic model with just enough capabilities and a good driver software package ($139). Also on back-order.

* `Minis <https://compocket.com/>`_ (10Ms/s, 2MHz bandwidth) is a low-cost option that runs software on your mobile phone ($149).


.. _msp432_boostxl_lib:

MSP432_BOOSTXL_LIB
^^^^^^^^^^^^^^^^^^

MSP432_BOOSTXL_LIB is a support library that offers support for flexible input/output
in a real-time DSP application. The library was specifically designed for this course and can be `consulted on github <https://github.com/wpi-ece4703-b20/msp432_boostxl_lib>`_.

The following is a list of the public functions defined in this library.

msp432_boostxl_init()
"""""""""""""""""""""""""

This function configures the processor clock of the ARM Cortex M4 to 48MHz. The function can be used when neither D/A nor A/D conversions are required.

.. code:: c

   #include "msp432_boostxl_init.h"

   void msp432_boostxl_init();


msp432_boostxl_run()
""""""""""""""""""""""""

This function starts the conversion process. Before calling this function the user must call one of the following initialization functions.

*  ``msp432_boostxl_init_poll()`` for polling mode conversion
*  ``msp432_boostxl_init_intr()`` for interrupt mode conversion
*  ``msp432_boostxl_init_dma()`` for dma mode conversion

.. code:: c

   #include "msp432_boostxl_init.h"

   void msp432_boostxl_run();


msp432_boostxl_init_poll()
""""""""""""""""""""""""""""""

This function configures the processor clock of the ARM Cortex M4 to 48MHz, turns on the microphone, and initializes the hardware in polling mode. In polling mode, the following steps are repeated as fast as the hardware allows: (1) An A/D conversion from a user-defined sources is completed, (2) a user-defined call-back function is executed with the converted sample as argument, (3) the value returned by the user-defined call-back function is forwarded to the D/A. The speed of A/D conversions is limited due to the speed of the successive approximation ADC in the MSP432. The speed of the D/A conversions is limited by the SPI connection between the MSP432 and the off-chip DAC8331.


.. code:: c

   #include "msp432_boostxl_init.h"

   void msp432_boostxl_init_poll(BOOSTXL_IN_enum_t  _audioin,
                                 msp432_sample_process_t _cb
                                 );

* ``BOOSTXL_IN_enum_t  _audioin`` indicates the source used by the ADC converter, and is one of the following selections.

  * ``BOOSTXL_MIC_IN`` the source signal is taken from the BOOSTXL board microphone
  * ``BOOSTXL_J1_2_IN`` the source signal is taken from pin 2 of header J1
   
* ``msp432_sample_process_t _cb`` is a pointer to the callback function called after ADC conversion.
  The callback function reads a 16-bit unsigned integer and returns a 16-bit unsigned integer, i.e.
  ``typedef uint16_t (*msp432_sample_process_t)(uint16_t);``
  

msp432_boostxl_init_intr()
""""""""""""""""""""""""""""""

This function configures the processor clock of the ARM Cortex M4 to 48MHz, turns on the microphone, and initializes the hardware in interrupt mode. In interrupt mode, a hardware timer is set to expire at a user-defined sample rate. When the hardware timer expires, an A/D conversion from a user-defined source is started. When the A/D conversion completes, a user-defined call-back function is called as part of the A/D interrupt service routine. The value returned from the user-defined call-back function is forwarded to the D/A. The audio processing thus proceeds at the user-defined sample rate. However, for correct operation, the processing time per sample must be smaller than the sample period. The processing time per sample is the sum of the execution time of the user-defined call-back function plus the time to make a D/A conversion. When the processing time per sample exceeds this sum, a timer interrupt will be lost and the sampling process will no longer reach the selected
user-defined sample rate.

.. code:: c

   #include "msp432_boostxl_init.h"

   void msp432_boostxl_init_intr(FS_enum_t          _fs,
                                 BOOSTXL_IN_enum_t  _audioin,
                                 msp432_sample_process_t _cb
                                 );

* ``FS_enum_t _fs`` selects the sample rate for the A/D and D/A conversion process.

   * ``FS_8000_HZ`` selects a sample rate of 8,000 Hz
   * ``FS_11025_HZ`` selects a sample rate of 11,025 Hz
   * ``FS_16000_HZ`` selects a sample rate of 16,000 Hz
   * ``FS_22050_HZ`` selects a sample rate of 22,050 Hz
   * ``FS_24000_HZ`` selects a sample rate of 24,000 Hz
   * ``FS_32000_HZ`` selects a sample rate of 32,000 Hz
   * ``FS_44100_HZ`` selects a sample rate of 44,100 Hz
   * ``FS_48000_HZ`` selects a sample rate of 48,000 Hz

* ``BOOSTXL_IN_enum_t  _audioin`` indicates the source used by the ADC converter, and is one of the following selections.

  * ``BOOSTXL_MIC_IN`` the source signal is taken from the BOOSTXL board microphone
  * ``BOOSTXL_J1_2_IN`` the source signal is taken from pin 2 of header J1
   
* ``msp432_sample_process_t _cb`` is a pointer to the callback function called after ADC conversion.
  The callback function reads a 16-bit unsigned integer and returns a 16-bit unsigned integer, i.e.
  ``typedef uint16_t (*msp432_sample_process_t)(uint16_t);``

msp432_boostxl_init_dma()
""""""""""""""""""""""""""""""

This function configures the processor clock of the ARM Cortex M4 to 48MHz, turns on the microphone, and initializes the hardware in DMA mode. In DMA mode, a hardware timer is set to expire at a user-defined sample rate. When the hardware timer expires, an A/D conversion from a user-defined source is started. When the A/D conversion completes, the sample is copied by a Direct Memory Access (DMA) module into a buffer. When a user-defined number of samples are gathered in the buffer, a user-defined call-back is called to process a block of samples. The user-defined call-back function
returns a block of samples from the same size. In dma mode, a hardware timer interrupt is then used to copy these output samples to the D/A module, one sample at a time. The DMA mode uses ping-pong
buffers to keep the sampling process and the data processing apart. There are two pairs of
ping-pong buffers: one pair is associated with the A/D conversion, and a second pair is associated with the D/A conversion.


.. code:: c

   #include "msp432_boostxl_init.h"

   void msp432_boostxl_init_dma (FS_enum_t          _fs,
                                 BOOSTXL_IN_enum_t  _audioin,
                                 BUFLEN_enum_t      _pplen,
                                 msp432_buffer_process_t _cb
                                );

* ``FS_enum_t _fs`` selects the sample rate for the A/D and D/A conversion process.

   * ``FS_8000_HZ`` selects a sample rate of 8,000 Hz
   * ``FS_11025_HZ`` selects a sample rate of 11,025 Hz
   * ``FS_16000_HZ`` selects a sample rate of 16,000 Hz
   * ``FS_22050_HZ`` selects a sample rate of 22,050 Hz
   * ``FS_24000_HZ`` selects a sample rate of 24,000 Hz
   * ``FS_32000_HZ`` selects a sample rate of 32,000 Hz
   * ``FS_44100_HZ`` selects a sample rate of 44,100 Hz
   * ``FS_48000_HZ`` selects a sample rate of 48,000 Hz

* ``BOOSTXL_IN_enum_t _audioin`` indicates the source used by the ADC converter, and is one of the following selections.

  * ``BOOSTXL_MIC_IN`` the source signal is taken from the BOOSTXL board microphone
  * ``BOOSTXL_J1_2_IN`` the source signal is taken from pin 2 of header J1

* ``BUFLEN_enum_t _pplen`` selects the size of the DMA ping-pong buffer.

  * ``BUFLEN_8`` selects a buffer size of 8 samples (for each ping buffer and each pong buffer)
  * ``BUFLEN_16`` selects a buffer size of 16 samples (for each ping buffer and each pong buffer)
  * ``BUFLEN_32`` selects a buffer size of 32 samples (for each ping buffer and each pong buffer)
  * ``BUFLEN_64`` selects a buffer size of 64 samples (for each ping buffer and each pong buffer)
  * ``BUFLEN_128`` selects a buffer size of 128 samples (for each ping buffer and each pong buffer)
   
* ``msp432_buffer_process_t _cb`` is a pointer to the callback function called after the ping-pong buffers have filled up. The calllback function has type ``typedef void (*msp432_buffer_process_t)(uint16_t *, uint16_t *)`` and takes two arguments. The first argument is a pointer to the input buffer of ``_pplen`` elements of type ``uint16_t``. The second argument is a pointer to the output buffer of ``_pplen`` elements of type ``uint16_t``. The callback function returns void.

measurePerfSample()
"""""""""""""""""""""""

This function measures the median execution time, counted in clock cycles, of a sample-based callback function such as used in polled mode and in interrupt mode. The measurement process proceeds as follows. The callback function is called 11 times, using a dummy (0) input argument. The return value of the callback function is ignored, and it is not forwarded to the D/A. Each of the 11 executions are measured using a hardware timer. The resulting set of cycle counts is sorted and the median (middle) element is returned. The measurement function adjusts the result and subtracts measurement overhead.

.. code:: c

   #include "msp432_boostxl_init.h"

   uint32_t measurePerfSample(msp432_sample_process_t _cb);

   * ``msp432_sample_process_t _cb`` is a pointer to the callback function called after ADC conversion. The callback function reads a 16-bit unsigned integer and returns a 16-bit unsigned integer, i.e. ``typedef uint16_t (*msp432_sample_process_t)(uint16_t);``


measurePerfBuffer()
"""""""""""""""""""

This function measures the median execution time, counted in clock cycles, of a buffer-based callback function such as used in dma mode. The measurement process proceeds as follows. The callback function is called 11 times, using a dummy input buffer of zeroes. The return buffer is ignored, and it is not forwarded to the D/A. Each of the 11 executions are measured using a hardware timer. The resulting set of cycle counts is sorted and the median (middle) element is returned. The measurement function adjusts the result and subtracts measurement overhead.


.. code:: c

   #include "msp432_boostxl_init.h"

   uint32_t measurePerfBuffer(msp432_buffer_process_t _cb);

* ``msp432_buffer_process_t _cb`` is a pointer to the callback function called after the ping-pong buffers have filled up. The calllback function has type ``typedef void (*msp432_buffer_process_t)(uint16_t *, uint16_t *)`` and takes two arguments. The first argument is a pointer to the input buffer of ``_pplen`` elements of type ``uint16_t``. The second argument is a pointer to the output buffer of ``_pplen`` elements of type ``uint16_t``. The callback function returns void.

errorledoff()
"""""""""""""

This function turns off LED 2 of the MSPEXP432P401R board.

.. code:: c

   #include "msp432_boostxl_init.h"

   void errorledon();


errorledon()
"""""""""""""

This function turns on LED 2 of the MSPEXP432P401R board.

.. code:: c

   #include "msp432_boostxl_init.h"

   void errorledoff();

adc14_to_q15
""""""""""""

This function converts a 14-bit ADC value to a fixed-point fix<16,15> Q15 value.
The encoded range spans [-0.25,0.25] corresponding to the analog range [0v, 3v3].

.. code:: c

   #include "msp432_arm_dsp.h"

   q15_t     adc14_to_q15(uint16_t v);

adc14_to_q31
""""""""""""

This function converts a 14-bit ADC value to a fixed-point fix<32,31> Q31 value.
The encoded range spans [-0.25,0.25] corresponding to the analog range [0v, 3v3].

.. code:: c

   #include "msp432_arm_dsp.h"

   q31_t     adc14_to_q31(uint16_t v);

adc14_to_f32
""""""""""""

This function converts a 14-bit ADC value to a single-precision floating point value.
The encoded range spans [-0.25,0.25] corresponding to the analog range [0v, 3v3].

.. code:: c

   #include "msp432_arm_dsp.h"

   float32_t adc14_to_f32(uint16_t v);

q15_to_dac14
""""""""""""

This function converts a fixed-point fix<16,15> Q15 value to a 14-bit DAC value.
The analog range spans [0v, 3v3] corresponding to range [-0.25,0.25].

.. code:: c

   #include "msp432_arm_dsp.h"

   uint16_t  q15_to_dac14(q15_t v);

q31_to_dac14
""""""""""""

This function converts a fixed-point fix<16,15> Q15 value to a 14-bit DAC value.
The analog range spans [0v, 3v3] corresponding to range [-0.25,0.25].

.. code:: c

   #include "msp432_arm_dsp.h"

   uint16_t  q31_to_dac14(q31_t v);

f32_to_dac14
""""""""""""

This function converts a single-precision floating point value to a 14-bit DAC value.
The analog range spans [0v, 3v3] corresponding to range [-0.25,0.25].

.. code:: c

   #include "msp432_arm_dsp.h"

   uint16_t  f32_to_dac14(float32_t v);


Examples
""""""""

This program calls the A/D conversion in polled mode.

.. code:: c

   uint16_t processSample(uint16_t in) {
     return 0x3FFF - in;
   }

   int main(void) {
      WDT_A_hold(WDT_A_BASE);

      msp432_boostxl_init_poll(BOOSTXL_J1_2_IN, processSample);

      msp432_boostxl_run();

      return 1;
  }

