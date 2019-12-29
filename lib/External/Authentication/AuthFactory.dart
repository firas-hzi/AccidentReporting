import 'AuthImplementation.dart';

class AuthFactory
{
     static AuthFirebaseImplementation getAuthFirebaseImplementation() 
    {
        return new AuthFirebaseImplementation();
    }
}