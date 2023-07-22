import 'package:flutter/material.dart';
import 'package:ria_bluetooth_controller/functionalities/bluetooth_manager.dart';

/*
Below class generate image by taking image path value as String,
 image Width as double, image height as double and opacity as double values
 from the constructor call for initializing the instance variables img,
  width, height, opacity
 */

class CreateImage extends StatelessWidget {
  final String img;
  final double? width;
  final double? height;
  final double? opacity;
  const CreateImage(this.img,{this.width,this.height,this.opacity,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return generateImage(img,imgWidth:width,imgHeight:height,imgOpacity:opacity);
  }

  Image generateImage(String image,{double? imgWidth,double? imgHeight,double? imgOpacity}){
    AssetImage assetImage=AssetImage(img);
    Image image=Image(image: assetImage,width: imgWidth,height: imgHeight,);
    return image;
  }

}


class CreateText extends StatelessWidget {
  final String text;
  const CreateText(String this.text,{Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class CreateIconButton extends StatelessWidget {
  final dynamic chooseIcon;
  final Function functionality;
  final dynamic iconColor;
  final double? iconSize;
  const CreateIconButton(this.functionality,this.chooseIcon,{this.iconColor,this.iconSize,Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){
      this.functionality;
    },
      icon: Icon(chooseIcon),
      color:iconColor,
      iconSize:iconSize,
      splashRadius: 0,
      splashColor: Colors.transparent,
    );
  }
}


class CreateIcon extends StatelessWidget {
  final dynamic chooseIcon;
  final iconSize;
  final iconColor;
  const CreateIcon(this.chooseIcon,{this.iconSize, this.iconColor, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Icon(chooseIcon,size:iconSize , color:iconColor ,);
  }
}


//Created a button using the Card widget, ListTile and
// used Marque functionality for the title if the title is greater than 6 letters in length

class CreateCardButton extends StatefulWidget {
  final  dynamic chooseIcon;
  final String titleText;
  final dynamic onCommand;
  final dynamic offCommand;
  final int letterLimit = 8;

  const CreateCardButton(this.chooseIcon,this.titleText,this.onCommand,this.offCommand,{Key? key}) : super(key: key);

  @override
  State<CreateCardButton> createState() => _CreateCardButtonState();
}

class _CreateCardButtonState extends State<CreateCardButton> {
  bool switchValue = false;
  Color cardColor = Colors.white;
  Color iconColor = Color.fromARGB(255, 39, 73, 110);
  Color textColor = Color.fromARGB(255, 39, 73, 110);


  void toggleSwitch(bool value) {
    setState(() {
      switchValue = value;
      if (switchValue) {
        cardColor = Color.fromARGB(255, 39, 73, 110);
        iconColor = Color.fromARGB(255, 250, 183, 38);
        textColor = Color.fromARGB(255, 250, 183, 38);
      } else {
        cardColor = Colors.white;
        iconColor = Color.fromARGB(255, 39, 73, 110);
        textColor = Color.fromARGB(255, 39, 73, 110);
      }
    });
  }

  void _sendCommand(String command) {
    BluetoothManager bluetoothManager = BluetoothManager();
    bluetoothManager.sendCommand(command);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),),
      color: cardColor,
      child: ListTile(
        leading: CreateIcon(widget.chooseIcon,iconColor:iconColor ,),
        title: Text(widget.titleText,style: TextStyle(fontWeight: FontWeight.bold,color: textColor)),
        onTap: (){
          toggleSwitch(!switchValue);
          switchValue?_sendCommand(widget.onCommand):_sendCommand(widget.offCommand);
        },
      ),
    );
  }
}

class createCircularAvatar extends StatelessWidget {
  final double _radius;
  final String _command;
  final IconData _chooseIcon;
  const createCircularAvatar(this._radius,this._command,this._chooseIcon,{Key? key}) : super(key: key);

  void _sendCommand(String command) {
    BluetoothManager bluetoothManager = BluetoothManager();
    bluetoothManager.sendCommand(command);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CircleAvatar(
        radius: _radius,
        child: Icon(_chooseIcon),
        // child: IconButton(onPressed:(){
        //   _sendCommand(_command);
        // } ,
        //     icon: Icon(_chooseICon)
        // ),
      ),onTap: (){
      _sendCommand(_command);
    },
    );
  }
}



