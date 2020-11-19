import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
class Config{

  static final String storageBucket = "gs://dewitte-28b7f.appspot.com/";




   ///  User constants

  static final String users = "Users";
  static final String admin = "admin";
  static final String address = "address";
  static final String userId = "userId";
  static final String email = "email";
  static final String height = "height";
  static final String weight = "weight";
  static final String age= "age";
  static final String location= "location";
  static final String loginMsg = "Login Successfull";
  static final String longitude = "longitude";
  static final String latitude = "latitude";
  static final String hasGeo = "hasGeo";




  static final String profilePicUrl = "profilePicUrl";
  static final String streetAddress = "streetAddress";
  static final String city = "city";
  static final String stateOrProvince = "stateOrProvince";
  static final String postalCode = "postalCode";
  static final String phone = "phone";
  static final String fullNames = "fullNames";
  static final String createdOn = "createdOn";
  static final String chosenLocation = "chosenLocation";
  static final String categories = "categories";
  static final String categoryName = "categoryName";
  static final String categoryId = "categoryId";
  static final String categoryImage = "categoryImage";
  static final String products = "products";
  static final String productId = "productId";
  static final String productImage = "productImage";
  static final String productName = "productName";
  static final String productPrice = "productPrice";
  static final String productQty = "productQty";
  static final String productDesc = "productDesc";
  static final String productStatus = "productStatus";
  static final String subTotal = "subTotal";
  static final String cartTotal = "cartTotal";
  static final String cart = "cart";
  static final String placed = "placed";
  static final String hasCookies = "hasCookies";


  static final String amount = "amount";
  static final String currency = "USD";
  static final String currencyDes = "currency";

  static final String createdBy = "createdBy";
  static final String delivery = "delivery";
  static final String pickup = "pickup";


  static final String cards = "cards";
  static final String card = "card";
  static final String cardId = "cardId";
  static final String cardNumber = "cardNumber";
  static final String cardHolderName = "cardHolderName";
  static final String cardMonth = "cardMonth";
  static final String cardYear = "cardYear";
  static final String cardType = "cardType";
  static final String cardDefault = "cardDefault";
  static final String cardCVC = "cardCVC";
  static final String cardExpiry = "cardExpiry";
  static final String deleted = "deleted";

  static final String wishes = "wishes";
  static final String coffee = "coffee";


  static final String contactUs= "contactUs";
  static final String feedback= "feedback";
  static final String feedbackId= "feedbackId";
  static final String message = "message";
  static final String orderId = "orderId";
  static final String contactUsId = "contactUsId";
  static final String inquiryId = "inquiryId";
  static final String inquiries = "inquiries";
  static final String store = "store";
  static final String orders = "orders";
  static final String pending = "pending";
  static final String id = "id";
  static final String ordersStatus = "orderStatus";
  static final String delivered = "delivered";
  static final String weekday= "weekDay";
  static final String time = "time";
  static final String from = "from";
  static final String fromHr = "fromHr";
  static final String fromMin = "fromMin";
  static final String toHr = "toHr";
  static final String toMin = "toMin";
  static final String to = "to";
  static final String weekDayId = "weekDayId";
  static final String dayNumber = "dayNumber";
  static final String activities = "activities";
  static final String userActivities = "userActivities";
  static final String activityId = "activityId";
  static final String activityName = "activityName";
  static final String activityImage = "activityImage";
  static final String subscribers = "subscribers";
  static final String sex = "sex";
  static final String smoke = "smoke";
  static final String drink = "drink";
  static final String ethnicity = "ethnicity";
  static final String profileVideoUrl = "videoUrl";
  static final String thumbnailUrl = "thumbnailUrl";

  static final String userType = "userType";
  static final String regularUser = "regularUser";
  static final String trainer = "trainer";




  static final String tokens = "tokens";
  static final String tokenId = "tokenId";
  static final String charges = "charges";
  static final String chargeId = "chargeId";
  static final String description = "description";
  static final String bio = "bio";


  static final String created = "created";
  static final String sessionRate = "sessionRate";
  static final String speciality = "speciality";
  static final String certName = "certName";
  static final String certId = "certId";
  static final String certUrl = "certUrl";
  static final String sessionType = "sessionType";
  static final String certificates = "certificates";
  static final String userCertificates = "userCertificates";
  static final String notificationToken = "notificationToken";


  static final String sources = "sources";
  static final String brand = "brand";
  static final String last4 = "last4";
  static final String exp_month = "exp_month";
  static final String exp_year = "exp_year";
  static final String customerId = "customerId";
  static final String customer = "customer";
  static final String error = "error";
  static final String paid = "paid";




  static final String trainerUserId = "trainerUserId";


  //chats

  static final String chats= "chats";
  static final String typing= "typing...";
  static final String imageUrl= "imageUrl";
  static final String messageType= "messageType";
  static final String messageId= "messageId";
  static final String lastMessage = "lastMessage";

  static final String notifications = "notifications";
  static final String notificationId = "notificationId";
  static final String notificationType= "notificationType";
  static final String notificationText = "notificationText";
  static final String senderId = "senderId";
  static final String receiverId = "receiverId";

  static final String text= "text";
  static final String start= "start";
  static final String image= "image";
  static final String chatThread= "chatThread";
  static final String receiver= "chatThread";
  static final String visible= "visible";
  static final String chatList= "chatList";
  static final String currentlyInSession = "currentlyInSession";
  static final String classSchedule = "classSchedule";

  static final String bookings = "bookings";
  static final String bookingDate = "bookingDate";
  static final String bookingDay = "bookingDay";
  static final String bookingStartHr = "bookingStartHr";
  static final String bookingEndHr = "bookingEndHr";
  static final String bookingEndMin = "bookingEndMin";
  static final String bookingStartMin= "bookingStartMin";
  static final String bookingStartTime = "bookingStartTime";
  static final String bookingEndTime = "bookingEndTime";
  static final String bookingMonth= "bookingsMonth";
  static final String bookingsYear= "bookingsYear";
  static final String bookingStatus = "bookingStatus";
  static final String bookingsId = "bookingsId";
  static final String userBookings = "userBookings";


  /// There are -- booking status
  /// Requested => User requests for  a trainer
  /// Approved => Trainer approves user request
  /// UnApproved => Trainer rejects users requests
  /// Paid => User pays for approved booking
  /// unpaid => User doesn't pay
  ///
  static final String approved = "approved";
  static final String requested = "requested";
  static final String unApproved = "unApproved";
  static final String unPaid = "unPaid";
  static final String cancel = "cancel";
  static final String cancelledBy = "cancelledBy";




  static final String updatedOn = "updatedOn";
  static final String completed = "completed";

  static final String booking = "booking";
  static final String presence = "presence";
  static final String expMonth = "expMonth";
  static final String expYear = "expYear";
  static final String paymentMethodId = "paymentMethodId";

  //notification Strings

  static final String sessionStarted = "started their session";
  static final String requestedToStartSession = "requested to start session";
  static final String sessionCancelled = "cancelled their session";
  static final String bookingSessionStarted = "bookingSessionStarted";
  static final String bookingSessionCompleted = "bookingSessionCompleted";
  static final String bookingSessionCancelled = "bookingSessionCancelled";
  static final String bookingSessionRequestToStart = "bookingSessionRequestToStart";












  static final String country= "country";
  static final String numOfPeople= "numOfPeople";
  static final String massageTherapist= "Massage Therapist";
  static final String pk_key= "pk_test_3NcEyxbZTpX24vEi3KpuQUef00h81LUz94";
  static final String visa= "Visa";
  static final String experience= "experience";
  static final String serviceArea= "serviceArea";
  static final String interestedActivities= "interestedActivities";



























  static Future<FirebaseApp> firebaseConfig() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'dewitte',
      options: Platform.isIOS
          ? const FirebaseOptions(
          googleAppID: '1:705814156355:ios:e46e053f5a6ae8a4',
          gcmSenderID: '705814156355',
          apiKey: 'AIzaSyCTJ9arMmoqzWWyuwofZMvmbrwPR7dMrlY',
          projectID: 'dewitte-28b7f',
          bundleID: 'com.relevantsys.dewitte')
          : const FirebaseOptions(
        googleAppID: '1:705814156355:android:e46e053f5a6ae8a4',
        apiKey: 'AIzaSyCTJ9arMmoqzWWyuwofZMvmbrwPR7dMrlY',
        projectID: 'dewitte-28b7f',
      ),
    );
    return app;
  }
}