# EEG_cocktail_decoding

Sample code and data for simple auditory attention decoding from EEG in the context of a two-speaker cocktail party paradigm 

Experiment:
Subjects were played audio clips in which there were two simultaneous talkers. They were tasked with attending to one of the two talkers. 

Auditory Attention Decoding Steps:

(1) Training: EEG of the subject listening to n-1 audio clips was regressed onto the acoustic envelope of the attended talker 
    using regularised linear regression (mTRF toolbox)
(2) Testing: Using the trained model, the acoustic envelope of the nth trial was reconstructed from EEG. If the envelope better 
    resembled the envelope of the attended talker, the trial is deemed to be correctly classified.
(3) This was repeated n times, repeating the trial to be tested to attain an average decoding accuracy
