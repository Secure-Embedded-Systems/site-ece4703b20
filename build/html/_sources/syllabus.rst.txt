.. ECE 4703 

.. _syllabus:

Syllabus
========


Instructor
^^^^^^^^^^

* Prof. Patrick Schaumont
* Office: Atwater Kent 301
* Office hour: Friday 9 AM - 10 AM
* Email: pschaumont@wpi.edu

Teaching Assistant
^^^^^^^^^^^^^^^^^^

* Hongjie Zgang
* Help Session: Tuesday 10 AM - 12 PM, AK 227
* Email: hzhang13@wpi.edu

Class and Lab Meeting Time
^^^^^^^^^^^^^^^^^^^^^^^^^^

* Lecture: **online**, M--R- 3 PM - 4:50PM, Oct 22 - Dec 10 (but not Nov 26)
* Lab: AK 227, --W-- 3 PM - 4:40PM, Oct 21 - Dec 9 (but not Nov 25)

.. important::

   * All Lectures will be held on Zoom 
   * All Zoom sessions will be recorded and available offline

Course Websites
^^^^^^^^^^^^^^^

* `canvas.wpi.edu <https://canvas.wpi.edu/courses/22127>`_: Announcements, Discussions, Grades
* `github.com <https://github.com/wpi-ece4703-b20>`_: Labs, Examples
* `schaumont.dyn.wpi.edu <https://schaumont.dyn.wpi.edu/ece4703b20/>`_: Lectures, Materials

Examination Schedule
^^^^^^^^^^^^^^^^^^^^

* Midterm Exam: Thursday, 12 November
* Final Exam: Thursday, 10 December

Course Description
^^^^^^^^^^^^^^^^^^

This course provides an introduction to the principles of real-time
digital signal processing (DSP). The focus of this course is hands-on
development of real-time signal processing algorithms using
audio-based DSP kits in a laboratory environment. Basic concepts of
DSP systems including sampling and quantization of continuous time
signals are discussed. Trade-offs between fixed-point and
floating-point processing are exposed. Real-time considerations are
discussed and efiicient programming techniques leveraging the
pipelined and parallel processing architecture of modern DSPs are
developed. Using the audio-based DSP kits, students will implement
real-time algorithms for various ltering structures and compare
experimental results to theoretical predictions. Recommended
background: ECE 2312, some prior experience in C
programming.

Expected Outcomes
^^^^^^^^^^^^^^^^^

Students who successfully complete this course should be able to:

* describe the architecture and basic operation of fixed-point and floating-point DSPs.
* perform worst-case timing analysis and measure execution time on real-time DSP systems.
* develop and realize computationally efficient algorithms on the DSP platform (e.g. FFT, fast convolution).
* optimize DSP code (e.g. software pipelining).
* draw block diagrams of FIR and IIR filters under various realization structures and describe the advantages and disadvantages of each realization structure.
* realize real-time FIR and IIR filter designs on the DSP platform, compare experimental results to theoretical expectations, and identify the source of performance discrepancies.

Expected Background
^^^^^^^^^^^^^^^^^^^

Students taking ECE4703 should have a basic understanding of discrete time signals and systems (ECE2312 or equivalent) including a working knowledge of sampling theory, basic filter design techniques, and frequency domain analysis. Students should also have an understanding of computer architecture as well as basic C and assembly language programming skills. Finally, students in ECE4703 are expected to have some experience programming in Matlab and an understanding of basic matrix/vector operations in Matlab.

Textbook and References
^^^^^^^^^^^^^^^^^^^^^^^

* *Digital Signal Processing Using the ARM Cortex-M4*, Donald S. Reay (Wiley). While the hardware required for the assignments is not identical to the hardware discussed in this book, the outline of the course will be very similar to the outline of this book.
* Refer to the course webpage under *Technical Documentation* for additional reference material. 

Course Work
^^^^^^^^^^^

The course includes weekly lab assignments (7), a midterm, and a final exam.

A small portion of your grade is for 'class participation'. That includes any online activity that
reflects your participation in the class such as asking questions and posting questions on the 
bulletin board.

+-------------------------------------+-----------------------+
| Course Work                         | Grade Weight          |
+=====================================+=======================+
| Lab assignments (report and code)   | 55% of the points     |
+-------------------------------------+-----------------------+
| Midterm                             | 20% of the points     |
+-------------------------------------+-----------------------+
| Final                               | 20% of the points     |
+-------------------------------------+-----------------------+
| Class Participation                 | 5% of the points      |
+-------------------------------------+-----------------------+


Grading Policy
^^^^^^^^^^^^^^

Final course grades are based on a student’s performance as follows:


+-------------------------------------+-----------------------+
| Letter Grade                        | Percentage            |
+=====================================+=======================+
| A                                   | 90 - 100              |
+-------------------------------------+-----------------------+
| B                                   | 80 - 90               |
+-------------------------------------+-----------------------+
| C                                   | 70 - 80               |
+-------------------------------------+-----------------------+
| D                                   | 60 - 70               |
+-------------------------------------+-----------------------+
| F                                   | < 60                  |
+-------------------------------------+-----------------------+

Course incompletes may be granted if the major part of the course is completed; however, no additional credit can be given for missed class discussions or teamwork beyond the end of the course.  In addition, in the case of an incomplete, the student is responsible for handing in the final work within the WPI required timeframe of one (1) year.  After this time, an incomplete grade changes to a failing (F) grade.


Late Work Policy
^^^^^^^^^^^^^^^^

Knowledge check quizzes and discussion boards will close at the deadline and no late work is accepted.  Individual homework problems and team submissions will be closed at the deadline unless an extension has been discussed with the instructor in advance of the deadline and authorized by the instructor in the form of a revised deadline. 

Academic Integrity
^^^^^^^^^^^^^^^^^^

You are expected to be familiar with the `Student Guide to Academic Integrity at WPI <https://www.wpi.edu/about/policies/academic-integrity/student-guide>`_. Consequences for violating the Academic Honest Policy range from earning a zero on the assignment, failing the course, or being suspended or expelled from WPI.

Common examples of violations include:

* Copying and pasting text directly from a source without providing appropriately cited credit
* Paraphrasing, summarizing, or rephrasing from a source without providing appropriate citations
* Collaborating on individual assignments
* Turning in work where a good portion of the work is someone else’s, even if properly cited

Academic Accomodations
^^^^^^^^^^^^^^^^^^^^^^

We strive to create an inclusive environment where all students are valued members of the class community. If you need course adaptations or accommodations because of a disability, or if you have medical information to share with us that may impact your performance or participation in this course, please make an appointment with us as soon as possible. If you have approved accommodations, please request your accommodation letters online through the Office of Disability Services student portal. If you have not already done so, students with disabilities who need to utilize accommodations for this course are encouraged to contact the Office of Disability Services as soon as possible to ensure that such accommodations are implemented in a timely fashion.

* Email – DisabilityServices@wpi.edu
* Phone – (508) 831-4908
* On Campus – Daniels Hall, First Floor 124


Tentative Schedule
^^^^^^^^^^^^^^^^^^

+-----------------+---------+-----------+----------------------------------------------------+
| **Lecture/Lab** | **Day** | **Date**  | **Topics**                                         |
+=================+=========+===========+====================================================+
| Lab 1           | W       | 10/21     | Introduction and tools: MSP432 with Audio XL, Code |
|                 |         |           | Composer Studio, Matlab, Github Classroom, Online  |
|                 |         |           | Learning                                           |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 1       | R       | 10/22     | Sampling and Quantization, Reconstruction          |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 2       | M       | 10/26     | Real-time Input/Output                             |
+-----------------+---------+-----------+----------------------------------------------------+
| Lab 2           | W       | 10/28     | FIR Filtering                                      |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 3       | R       | 10/29     | DTFT, z-transform, and FIR filters                 |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 4       | M       | 11/2      | FIR Implementation                                 |
+-----------------+---------+-----------+----------------------------------------------------+
| Lab 3           | W       | 11/4      | IIR Filtering                                      |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 5       | R       | 11/5      | IIR Design Techniques and Tools                    |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 6       | M       | 11/9      | Fixed Point DSP                                    |
+-----------------+---------+-----------+----------------------------------------------------+
| Lab 4           | W       | 11/11     | Fixed Point Refinement                             |
+-----------------+---------+-----------+----------------------------------------------------+
| Midterm         | R       | 11/12     |                                                    |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 7       | M       | 11/16     | Performance Optimization of DSP Programs           |
+-----------------+---------+-----------+----------------------------------------------------+
| Lab 5           | W       | 11/18     | Performance Optimization                           |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 8       | R       | 11/19     | DSP Libraries                                      |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 9       | M       | 11/23     | Adaptive Filters                                   |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 10      | M       | 11/30     | Frequency Synthesis and Detection                  |
+-----------------+---------+-----------+----------------------------------------------------+
| Lab 6           | W       | 12/2      | AFSK Demodulator                                   |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 11      | R       | 12/3      | Fast Fourier Transform                             |
+-----------------+---------+-----------+----------------------------------------------------+
| Lecture 12      | M       | 12/7      | Applications of the Fast Fourier Transform         |
+-----------------+---------+-----------+----------------------------------------------------+
| Lab 7           | W       | 12/9      | Wrap-up                                            |
+-----------------+---------+-----------+----------------------------------------------------+
| Final Exam      | R       | 12/10     |                                                    |
+-----------------+---------+-----------+----------------------------------------------------+
