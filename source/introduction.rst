.. ECE 4703 

Introduction 
============

The purpose of this lecture is as follows.

* Make an overview of the course including required work, prerequisites, exams/tests to complete.
* Describe the equipment used in the lab.
* Enumerate the software and hardware requirements.
* Introduce Lab 1.

Overview of the course
^^^^^^^^^^^^^^^^^^^^^^

The best place to start this course is by reading the :ref:`syllabus`.

* Lectures as well as labs will be broadcast and recorded on `Zoom <https://wpi.zoom.us/j/95668047398>`_.
* Lectures will be completely online, while labs will use a hybrid/online format.
* The syllabus includes a tentative schedule of the lectures and labs. This schedule may be adjusted and refined throughout the semester.

Navigating the course
"""""""""""""""""""""

We will use three websites related to this course.

* `canvas.wpi.edu <https://canvas.wpi.edu/courses/22127>`_ is used for announcements, discussions (chat) and course grades. Make sure to refer to Canvas for announcements regarding the class meeting times, arrangements for labs and tests, and so forth. Also, there is a discussion forum where you can post questions. You can send me and/or the TA email, but if your question would benefit the class as a whole, then the answer will be posted on the discussion forum.

* `github.com <https://github.com/wpi-ece4703-b20>`_ is used to exchange source code. Labs and in-class examples will appear as repositories on github. **You must have a Github account to participate in this class**. If you don't have a Github account, prepare one as soon as possible. Github accounts are free.

* `schaumont.dyn.wpi.edu <https://schaumont.dyn.wpi.edu/ece4703b20/>`_ is used to post Lectures, Lab assignments, Reading assignments, and more.


Lab Equipment
"""""""""""""

You will receive a loaner kit with an MSPEXP432P401R controller board, an BOOSTXL-AUDIO analog interface,
and a BS05 bitscope (USB oscilloscope) with BNC probe connector. A 'loaner' kit means that you have to
return the equipment at the end of the term. We will collect the instrument before the final exam.

If your kit breaks during the term, please notfiy the TA or the instructor right away. In return for your
broken kit you may receive a replacement kit.


Getting Started: Checklist
""""""""""""""""""""""""""

Before you start with the first Lab, you have to prepare the following.

* Form a team with up to three students per team. 
* Install Code Composer Studio on your laptop.
* Install the Bitscope DSO software on your laptop.
* Unpack and assemble the hardware.
* Get a Github account, if needed.
* Follow the instructions for :ref:`lab1`

.. comment:

   =======================================================
   Lecture 1: Sampling and Quantization, Reconstruction 
   
   - Why do we process data digitally?
   - Sampling Analog signals
     Discrete Time Signals
     Spectrum of Discrete Time Signals
     Practical: A/D conversion
   - Reconstruction
     Perfect reconstruction
     Practical reconstruction
     	Zero order hold
     	Low-pass filter
   - Quantization
       span
       resolution
       voltage resolution
       conversion formulas
   - Example: loopback
