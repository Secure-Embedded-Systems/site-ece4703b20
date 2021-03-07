.. ECE 4703 

How-To Guides
==============

On this page you find short instructional guides to project tasks and experimental work.

Measurements and Experiments
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

How do I find the COM port used by Bitscope?
""""""""""""""""""""""""""""""""""""""""""""

For the Bitscope to function properly, you have to configure the proper COM port
in the Bitscope setup. Here is how you can identify the proper COM port.

On Windows, open the device manager (by running 'Device Manager' from the search prompt).
Look for the entry **Ports (COM & LPT)**. If the MSP-EXP432P401R kit and the bitscope are 
both connected, you will find three COM ports are in use.

In the Bitscope setup, you would now use **COMz** as the proper configuration, where z is an integer.
Examples are COM16, COM17, etc.

+----------------------------------------------+--------------------------------------------------+
| Device Manager Entry                         | Purpose                                          |
+==============================================+==================================================+
| XDS110 Class Application/User UART (COMx)    | User UART for the MSP432P401R                    |
+----------------------------------------------+--------------------------------------------------+
| XDS110 Class Auxiliary Data Port (COMy)      | Programming/debug port for MSP432P401R           |
+----------------------------------------------+--------------------------------------------------+
| USB Serial Port (COMz)                       | Bitscope data port                               |
+----------------------------------------------+--------------------------------------------------+

How do I minimize the noise in the measured bitscope signal?
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Even though we are measuring signals with a relatively small bandwidth, it's still possible to
pick up a lot of noise, such as shown in the following trace.

.. figure:: images/noisy.jpg
   :figwidth: 600px
   :align: center

This noisy image was recorded at 200mV/div, indicating there is significant disturbance.
In this case, the noise was caused by improper grounding of the measurement setup.
As shown in the setup, both the waveform generation signal, and the measured DAC output
are measured using a single wire without ground. The net effect is a 'ground loop', where the common
ground between MSP-432 kit and the bitscope runs through the USB cables.

.. figure:: images/nognd.jpg
   :figwidth: 300px
   :align: center

With proper grounding, we obtain a clean signal. 
While grounding cannot eliminate all sources of interference, it will be
a major contribution to measuring sharp traces in your DSP experiments.

.. figure:: images/nomorenoisy.jpg
   :figwidth: 600px
   :align: center

Provide a ground signal for every live signal. You can use wire pairs and
connect the ground signal on the MSP-432 kit side as well as on the bitscope side. The bottom header pins of the
Hammerhead extension are all grounded.

.. figure:: images/withgnd1.jpg
   :figwidth: 300px
   :align: center

.. figure:: images/withgnd2.jpg
   :figwidth: 300px
   :align: center


Software Development
^^^^^^^^^^^^^^^^^^^^

How do we add a project to our local Github repository?
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

1. Right-click on the non-repo project and select 'Team .. share ..'
2. In the project sharing window, select the repository you want to add it to. Use the pull-down selector to get a list of currently-used repositories

How do we return code to Github from within Code Composer Studio?
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

1. Right-click on your project in the project explorer and select 'Team .. commit ..'. Note: If you don't see 'Team .. commit ..' but only 'Team .. share ..', then your project is not included in a repository yet. Consult the previous question (How do we add a project to our local Github repository)
2. In the 'Git Staging' window that appears, make sure that all the files you have changed are in the 'Staged Changes' window. Drag them from 'Unstaged Changes' to 'Staged Changes' if needed.
3. In the 'Git Staging' window, add a comment message
4. In the 'Git Staging' window, click on 'Commit and Push'. It's a good idea to open a browser afterwards, go to github.com and verify that your repository has been updated with your code. 

Digital Signal Processing Theory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

How do I go from z-plan poles and zeroes to G(z) and vice versa?
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The filter transfer function :math:`G(z)` and its z-plane features are related as follows.
Writing :math:`G(z)` as :math:`\frac{N(z)}{D(z)}`, then the zeroes of :math:`G(z)` are the values of z
where :math:`N(z)` is zero, and the poles of :math:`G(z)` are the values of z where :math:`D(z)` is zero.

**From z-plane to G(z)**


Here's an example. Pick a point in the z-plane defined by :math:`A.e^{j.\phi}`. To create a zero, we would
form the expression

.. math::

	N(z) = z - A.e^{j.\phi}

We are used to see G(z) written in terms of :math:`z^{-1}`. So, let's introduce :math:`D(z) = z` and compute
:math:`G(z)`.

.. math::

	G(z) =& \frac{N(z)}{D(z)} \\
	     =& \frac{z - A.e^{j.\phi}}{z}      \\
         =& \frac{1 - A.e^{j.\phi}.z^{-1}}{z^{-1}}

In order to make G(z) causal (i.e., only negative powers of z), we are introducing a pole at the
center of the unit circle. G(z) has the following impulse response: :math:`1`, followed by :math:`- A.e^{j.\phi}`.

When G(z) needs to have real coefficients, the zeroes (and poles) have to appear in conjugate pairs.
Let's for example create an H(z) containing two zeroes, one at :math:`A.e^{j.\phi}` and one at
:math:`A.e^{-j.\phi}`, then we would create:

.. math::

	H(z) =& \frac{(1 - A.e^{j.\phi}.z^{-1}).(1 - A.e^{-j.\phi}.z^{-1})}{z^{-2}}   \\
         =& \frac{1 - 2.A.cos(\phi).z^{-1} + z^{-2}}{z^{-2}}

To make H(z) causal, we have to introduce a double pole at the center of the unit circle.

**From G(z) to z-plane**


We use a root finding program, such as the ``roots`` function in Matlab.

Here's an example. If you have the following G(z)

.. math::

	G(z) = 1 + 2.z^{-1} + 4.z^{-2}

Then we would have the following equation in terms of z:

.. math::

	G(z) = \frac{z^2 + 2.z + 4}{z^2}

In matlab we would compute ``roots([1 2 4])`` which gives a complex conjugate pair :math:`-1.0000 \pm 1.7321i`. This corresponds to two
zeroes located outside of the unit circle.






.. * :ref:`faq1`
.. 
.. .. _faq1:
.. 
.. How to Download and Install Code Composer Studio
.. ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. 
.. .. raw:: html
.. 
..     <iframe height="360" width="640" allowfullscreen frameborder=0 src="https://echo360.org/media/30c51458-4793-4063-b812-3c3358cbc0be/public?autoplay=false&automute=false"></iframe>
