import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRepository{

  Firestore _firestore ;


  BookingRepository.instance() : _firestore = Firestore.instance;


}