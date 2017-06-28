---
title: Patterns of Amplitude Modulation in Drosophila Auditory Communication 
author: Akiva Lipshitz
date: June - August 2017
---

This will begin as a rough outline of what I want to say and over the course of the summer will be updated as new insight arrives. 

The goal is to figure out what features in visual stimuli induces amplitude modulation in Drosopila Melanogaster and eventually build a dynamical system model for describing this phenomenon. These questions are answered using a novel experimental setup wherein a fly is immersed in a virtual reality environment. The fly's visual field can be controlled by the experimenter , to the extent that the fly can be presented arbitrary visual stimuli and its subsequent response recorded.

My task is to build upon previous knowledge and try to determine what precisely activates amplitude modulation as well as the quirks involved in such modulation. We effectively have a binary search space of variables $\mathbf{x}$ and an activation function $y=\sigma(\mathbf{Wx})$ which tells us whether amplitude modulation is present in situation $\mathbf{x}$. This is a perceptron network classifier.  

## Ideas

- It would be quite interesting to build a recurrent neural network model (beginning with visual input) for reproducing the effect and possibly generalize so as to predict the correct output of $\sigma(Wx)$ without having been trained on such data. 

## Notes

TODO: Review physics of audio waves and how they are detected by fly ears.
We need to compute sound intensity as a function of wing velocity. 

## Brainstorming/Questions To Answer

There are vertical as well as horizontal challenges. The horizontal challenges require thought and the vertical challenges require experimental computation. 

- How do flies perform distance detection
  - Is there an auditory element to distance modulation, or any sensory information beyond visual?
- What kind of processing would be involved? Can we flip or perturb circuitry to change
  what modulates amplitude. 
- Can we optogenetically change auditory amplitude?
- Do flies with curved wings exhibit amplitude modulation?
- What are the physical and neurobiological constraints on amplitude
  modulation? Can a *wing-flap* signal be interrupted or must the fly wait
  until completion?
- What is the physical process by which amplitude is actually modulated? Is
  it flap velocity? Note: $v=lf$ such that $v ~ f$ and $v ~ l$, or something
  not here thought of? That's why it's important to review the physics of
  sound. 
- What is the timescale/timescale resolution of amplitude modulation?
- Is it a simple function of distance or is there a temporal or stochastic element as well?
- Is there a conserved quantity, such as observed amplitude, or is there always some error between what the observed fly should hear vs what it actually does hear?
- What kinds of covariates go along with amplitude besides for distance, i.e. what neural dynamics corresponds to high amplitude. Is it frequency or something else? How do the muscle neurons decode frequency into strength?
- What kinds of setups make the fly incorrectly measure the amplitude/incorrect response. In other words, what are the anomalies in AMD? 
- Does blinding one eye effect the fly's ability to assess distance? What if you deafen the fly; is it still able to correct for distance?
- Do flies have an IMU for other flies, such that if you turn off the lights, what is the the timescale of MSE saturation. **Sound is an appropriate proxy for predictive capacity**.

