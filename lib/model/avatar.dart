import 'dart:math';

class Avatar{
  String path;

  List accessoriesType = ["Circle", "Transparent"];
  List avatarStyle = ["Circle", "Transparent"];
  List clotheColor = ["Black", "PastelBlue", "Pink"];
  List clotheType = ["Hoodie", "GraphicShirt", "OverAll"];
  List eyeType = ["Cry", "Wink" , "Dizzy"];
  List eyebrowType = ["Unibrownatural", "UpDown", "Angry"];
  List facialHairColor = ["Auburn", "Red"];
  List facialHairType = ["Blank", "MoustacheFancy"];
  List graphicType = ["Skull", "Diamond"];
  List hairColor = ["Blonde", "Black", "Red", "SilverGray"];
  List hatColor = ["Black", "Red"];
  List mouthType = ["Twinkle", "Eating", "Smile"];
  List skinColor = ["Pale", "Brown", "Black"];
  List topType = ["NoHair", "Hijab", "LongHairFro"];

  List categories;
  Map<String,String> selected = Map<String, String>();

  Avatar(){

  }

  String getRandom(){
    var rng = new Random();

    return "https://api.adorable.io/avatars/245/${rng.nextInt(100000)}.png";
  }



  Avatar.fromDatabase(this.path);





  
  


  
}





/*
https://avataaars.io/?
accessoriesType=Round
&avatarStyle=Transparent
&clotheColor=Pink
&clotheType=Overall
&eyeType=Dizzy
&eyebrowType=Angry
&facialHairColor=Red
&facialHairType=MoustacheFancy
&graphicType=Diamond
&hairColor=Black
&hatColor=PastelRed
&mouthType=Smile
&skinColor=Black
&topType=LongHairCurvy
*/
