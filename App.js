/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

 import React, { Component } from "react";
 import {
   Image,
   Platform,
   StyleSheet,
   Text,
   View,
   TouchableOpacity,
   requireNativeComponent,
   TouchableHighlight,
   NativeModules
 } from "react-native";

// const CounterView = requireNativeComponent("CounterView")
const myImage = require('./my_image.png');
const resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource');
const resolvedImage = resolveAssetSource(myImage);


 export default class App extends Component {

 // done = false
   constructor(props) {
    super(props)
    this.state = { done: false }
  }

   _changeView(index) {
     this.setState({ done: false })
     // this.state.done = false;
     this.render();
     // 0- canvas, 1- Camera, 2- Gallery

     const me = this
     NativeModules.ChangeViewBridge.startEditingImage([index, resolvedImage], (error, data) => {
         if (error) {
            console.log(error);
         } else {
            console.log("Completed Image Editing");
            console.log(data);
         }
         me.setState({ done: true })
         // alert("Completed editing ")
         me.render();
     });
   }

 render() {
   if (!this.state.done) {
     return (
       <View style={styles.container}>
         <TouchableHighlight onPress={() => this._changeView(1)}>
           <Text color="#336699">
             Camera
           </Text>
         </TouchableHighlight>
         <Text color="#336699">
         </Text>
         <Text color="#336699">
         </Text>
         <TouchableHighlight onPress={() => this._changeView(2)}>
           <Text color="#336699">
             Gallery
           </Text>
         </TouchableHighlight>
         <Text color="#336699">
         </Text>
         <Text color="#336699">
         </Text>
         <TouchableHighlight onPress={() => this._changeView(0)}>
           <Text color="#336699">
             Canvas
           </Text>
         </TouchableHighlight>
         <Text color="#336699">
         </Text>
         <Text color="#336699">
         </Text>
       </View>
     );
   } else {
     return (
       <View style={[styles.container, "backgroundColor":"red"]}><Text color="#336699" style = {{width:100, height:100}}>
         Completed Editing
       </Text>
       <Image
          style={{width:200, height:300}}
          source={{uri: '~/Documents/edited_image.png', scale:1}}
       />
       </View>
     );
   }
 }
};

 const styles = StyleSheet.create({
   container: {
     flex: 1,
     justifyContent: 'center',
     alignItems: 'center',
     backgroundColor: '#F5FCFF',
   }
 });
