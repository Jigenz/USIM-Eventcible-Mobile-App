
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class FirebaseServices{
 final _auth= FirebaseAuth.instance;
 final _googleSignIn= GoogleSignIn();


  signInWithGoogle() async{
    try{
      final GoogleSignInAccount? googleSignInAccount= await _googleSignIn.signIn();
      if(googleSignInAccount!=null){
        final GoogleSignInAuthentication googleSignInAuthentication= await googleSignInAccount.authentication;
        final AuthCredential credential= GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        final UserCredential userCredential= await _auth.signInWithCredential(credential);
        final User? user= userCredential.user;
        if(user!=null){
          return user;
        }
      }
    }on FirebaseAuthException catch(e){
      print(e.message);
      throw e;
    }


  }

  signOut() async{
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

}
