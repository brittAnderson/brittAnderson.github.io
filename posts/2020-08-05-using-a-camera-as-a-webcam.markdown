---
title: Using Your Camera As A Webcam
author: Britt Anderson
---

This is a popular topic in the era of work from home and remote presentations. I just wanted to post as landmarks a couple of useful links I found helpful. In addition I want to point out that you can make most of this work in Linux and using Nixos in particular if you are so inclined.

The easiest route if you are a Windows or Mac user is to simply buy a supported Canon camera and use their [beta software](https://www.canon.ca/en/Features/EOS-Webcam-Utility "Canon Canada Beta Webcam"). Then everything seems to just work. However, if you are on linux the story is more complicated.

One option is to buy the cheapest HDMI-USB video converter you can find and cross your fingers the lag is adequate for your use. 

Another option is to search the [gphoto2](http://gphoto.org/proj/libgphoto2/support.php "gphoto2 supported cameras") list of supported cameras and then, if yours is supported, search for specfic instructions. 

In my case I followed the advice in this [youtube video](https://youtu.be/EqrZrKC1WA0 "Using OBS to Stream Without special software") and set up a loopback device. The packages you need are shown for Ubuntu and the pace is slow, but methodical. You can skim if you know what you are doing. If you do not this is a nice overview. 

As I tried to get things in my nixos installation working I tried a bunch of settings and packages. I will list them here, but they may not all be necessary for you.

First, are the changes I made to my `configuration.nix`

I set a kernel package:

`boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];`

I also installed the package `linuxPackages.v4l2loopback` and some others for my applications and uses. The `screenkey` program allows you to show keypresses on the screen and is useful for screencasting. 

    zoom-us
	ffmpeg
    gphoto2
    screenkey

And I enabled the gphoto option `programs.gphoto2.enable=true;`
  
  
For reasons I can\'t quite remember I decided to only make the obs_studio package available for my user account, and I added the camera to my list of extra groups:

	extraGroups = [ "wheel" "networkmanager" "adbusers" "camera"];
    packages =  with pkgs; [
    	pkgs.obs-studio 

Then if all that installs, compiles and works well you can plug in your camera from its USB out to a USB port on your computer and then reboot all. In a terminal check if gphoto2 can find your camera with `gphoto2 --autodetect`

Figure out the names of your video devices with `ls /dev/video*` and then 

	sudo modprobe v4l2loopback

and repeat the `ls` command to identify the new device, and use it to run:

	  gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo 
		  -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video2
	  
Now you should have a dummy device you can use in obs or zoom or pretty much any application. 
