# LaborLink: A Labor-hailing Android Application with ID and Face Verification using Convolutional Neural Networks and Computer Vision

<p align="center">
   <img src="https://github.com/user-attachments/assets/26de2615-cf9c-4e55-aa98-1d57d9439e09" width="500" />
</p>

## Summary

In today's fast-paced world, finding the time for essential home repairs can be a challenge, leading many to rely on professional handymen. However, the proliferation of untrustworthy individuals posing as handymen has raised concerns about theft, subpar work, and a lack of necessary skills. LaborLink utilizes advanced technologies such as Convolutional Neural Networks (CNN) for anomaly detection and Computer Vision for face verification to verify worker credentials and ensure user authentication, connecting users with genuine, skilled, and reliable handymen. This mitigates the risks associated with hiring and provides households with a secure, efficient way to access professional services. Addressing existing platform deficiencies, this project proposes a transformative labor-hailing app that aims to comprehensively tackle these challenges with an intelligent verification system, a user-centric interface design, standardized user profiles, reviews, and a robust reporting system. Ultimately, this project seeks to revolutionize the labor-hailing industry by offering a seamless, secure, and user-oriented solution that enhances both customer satisfaction and handyman efficiency.

### *Objectives:*
1. Provide a seamless flow for booking handymen
<p align="center">
   <img src="https://github.com/user-attachments/assets/666a4176-e5da-40b3-85ff-75ea997d62e5" width="200" />
   <img src="https://github.com/user-attachments/assets/99e5a844-b30b-441e-a2b4-c68dca56e9fc" width="200" />
   <img src="https://github.com/user-attachments/assets/ec2d38d9-55e4-498f-8d90-c63042bdbb6d" width="200" />
</p>

2. Implement a user-centric and standardized interface for prioritizing updates, transparency, feedback, and communication for users,
<p align="center">
   <img src="https://github.com/user-attachments/assets/504102ac-3f6c-405a-9556-9207ba56d445" width="200" />
   <img src="https://github.com/user-attachments/assets/128925ed-c0ae-409a-8ff0-ff7598e4a4f9" width="200" />
   <img src="https://github.com/user-attachments/assets/e606223f-d33f-4a45-908a-71632114e688" width="200" />
</p>

3. Utilize a “buyer/client-determined” reversed auction mechanism
<p align="center">
   <img src="https://github.com/user-attachments/assets/a195a8a0-857f-417f-8548-534f4dfc5870" width="200" />
   <img src="https://github.com/user-attachments/assets/7c5ed693-0c8f-44be-b147-b8d26578f971" width="200" />
</p>

4. Identify and authenticate end-users through ID Verification using Convolutional Neural Networks for Anomaly Detection and Computer Vision for Face Detection and ID Matching.
<p align="center">
   <img src="https://github.com/user-attachments/assets/c8ba231f-a48a-4b94-823a-ff5f412e9886" width="200" />
   <img src="https://github.com/user-attachments/assets/97288093-1960-4b2a-9931-7b7c673c9b5d" width="200" />
   <img src="https://github.com/user-attachments/assets/849a38e4-84b3-4401-b1be-24f72a9905be" width="200" />
</p>

### *Firebase*
Firebase(NoSQL) was used for handling the database of the app (Firestore DB, Storage) and other authentication features of the app like user login, email and phone authentication (FireAuth).

### *CNN and Computer Vision*
The ID verification has two parts: Document anomaly detection and face verification. 
- Convolutional neural network-based autoencoders were used for training on normal data and reconstruction for detecting anomalies. Density threshold and reconstruction error were used as metrics to flag anomalies. This was developed separately using Python, libraries useful for image manipulation (such as PIL, numpy, and matplotlib), and Tensorflow and Keras in Google Colab. A Python Flask API was then built for the CNN-based autoencoder script hosted through PythonAnywhere.
- FirebaseVision and ML Kit were used along with Regula Face SDK API and some flutter packages useful for image handling for the face verification. 

## Known Issues
- [ ] Reading and writing data and Uploading and loading media files can be slow at times (Firebase Spark/Free plan)
- [ ] ID verification process, specifically document anomaly detection, appears to be intermittent when using mobile data

## Future Features
- [ ] Credit balance - allows credit balance payment through app for successful transaction
- [ ] Payment API - provides convenient online transaction for all users using payment APIs like PayMongo
- [ ] Google Map Pin for Address - helps users to navigate and pin locations




