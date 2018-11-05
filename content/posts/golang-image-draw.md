---
title: "Fun with Golang image package"
date: 2018-11-04T00:29:59-04:00
draft: false

categories: ["Golang", "Programming"]
tags: []
author: "Phuc Duong"
---

**Note**: All the source code in this post are contained in once single `main.go` file.  
You can also get the code from [Github repo](https://github.com/phucduong86/go-image.git)
### The idea

I wanted to recreate Facebook's rainbow filter programmatically. In this basic program I'll implement a function that takes in an image and generate a new one with the filter applied. The idea is to have the before and after effect on my little gopher that looks like this:  
  
![Gopher Avatar](/images/golang-image-draw/gopherized.jpg)
![New Gopher Avatar](/images/golang-image-draw/rainbowedGopherized.jpg)

### Challenge Breakdown

To archive the above effect, the procedure can be brokendown to a few steps:  

1. Create a new empty file
2. Draw the given image on it (basically make a copy)
3. Create a rainbow image with the same dimensions of the new image.  
4. Overlay the rainbow on top of the current new image, with appropreate opacity so that we can still see the original image.
5. Encode and save the image to a new file.


### The basic


**Generate an image**  
Let's create a function that generate a new image with the given file name and dimensions. 

```
func generateImage(filename string, width, height int) {
	myImage := image.NewRGBA(image.Rect(0, 0, width, height))
	for i := 0; i < (width * height * 4); i++ {
		myImage.Pix[i] = 122
	}
	// outputFile is a File type which satisfies Writer interface
	outputFile, err := os.Create(filename)
	checkErr(err)
	defer outputFile.Close()
	// Encode takes a writer interface and an image interface
	// We pass it the File and the RGBA
	jpeg.Encode(outputFile, myImage, &jpeg.Options{100})
	checkErr(err)
	fmt.Println("Generated ", filename)
}
```
The first important line:
```
myImage := image.NewRGBA(image.Rect(0, 0, width, height))
```
The code above create a new RGBA object the satisfies the image.Image interface with the given "width" and "height". All of its colors can be accessed via a one dimensional slice **myImage.Pix**.  

Imagine a 3 dimensional 2 pixels by 2 pixels image:
```
Pixel[0] Pixel[1] Pixel[2]   
Pixel[3] Pixel[4] Pixel[5]
```
**myImage.Pix** slice would be a slice with 3 * 2 * 4 = 24 elements where:  
- myImage.Pix[0:4] hold Pixel[0]'s R,G,B and A value  
- myImage.Pix[4:8] hold Pixel[1]'s R,G,B and A value  
- and so on.  

In the example above, I've taken the lazy route of setting all the pixels' colors to RGBA{122,122,122,122}.  
Obviously, there must be a more efficient way to do this, here comes `func (p *RGBA) SetRGBA(x, y int, c color.RGBA)`.   
With this method, we can set the RGBA color value to the pixel at **x, y** coordinate on the image:
```
newImg.SetRGBA(0, 0, color.RGBA{255,255,255,255})
newImg.SetRGBA(0, 1, color.RGBA{0,0,0,255})
...
```
Now we can actually use what we just learned to make a rainbow:
```
//Define all the colors so we can use them later
var (
	red    = color.RGBA{255, 0, 0, 150}
	orange = color.RGBA{255, 127, 0, 150}
	yellow = color.RGBA{255, 255, 0, 150}
	green  = color.RGBA{0, 255, 0, 150}
	blue   = color.RGBA{0, 0, 255, 150}
	indigo = color.RGBA{75, 0, 130, 150}
	violet = color.RGBA{148, 0, 211, 150}
)

var colors = []color.RGBA{red, yellow, orange, green, blue, indigo, violet}

func makeRainbow(filename string, width, height int) {
	//Create a new file that we can save the rainbow image to later
	imageFile, err := os.Create(filename)
	checkErr(err)
	defer imageFile.Close()

	//Generate a new RGBA image
	newImg := image.NewRGBA(image.Rect(0, 0, width, height)) //image.Image type

	//We have to do a bit of math here
	//We basically divide the image into 7 equal sections horizontally
	//Iterate through all the pixels and set the colors depends on where it is
	for i := 0; i < width; i++ {
		for j := 0; j < height; j++ {
			row := int(float64(j) / (float64((height + 7) / 7))) //height-7 eliminate the edge case when row is calculated to 7
			newImg.SetRGBA(i, j, colors[row])
		}
	}
	//Encode the image.Image object in png format and save it to imageFile.
	png.Encode(imageFile, newImg)
	checkErr(err)
	fmt.Println("Made rainbow: "+filename+" width and height: ", width, height)
}
```
An important note here is that the rainbow image needs to be encoded in png format so that it preserve the Alpha property, which result in the opacity effect when it is drawn on top of another image.
**Another helper: Get an image's dimensions**

There are more than 1 way to acquiring the dimensions of an image. This is a common solution: decoding the file to image.Image object and call the Bounds() method to retrieve the dimensions

```
func getImgDimensions(filename string) {
	imageFile, err := os.Open(filename)
	checkErr(err)
	defer imageFile.Close()

	decodedImg, err := jpeg.Decode(imageFile)
	dimensions := decodedImg.Bounds()
	fmt.Println("width: ", dimensions.Dx(), " Height: ", dimensions.Dy())
}
```

You can also explore the DecodeConfig function in the "image" package as well.  
### Recap
With the functions we created above, we can cover a good chunk of the broken down process:
- Create a new file
- Get an image's dimension
- Generate an image of a rainbow with given dimensions.

### The final bits
Go comes with a powerful built in package for manipulating and composing images. I consulted a great article on this topic on [Go Blog](https://blog.golang.org/go-imagedraw-package). 

Utilise the `draw.Draw(...)` I was able to implement the rest of the logic:
```
func rainbowOverlay(givenFilename, newFilename string) {
	//get the given image's dimension
	givenFile, err := os.Open(givenFilename)
	checkErr(err)
	defer givenFile.Close()
	givenImg, _, _ := image.Decode(givenFile)
	dimensions := givenImg.Bounds()

	makeRainbow("rainbow.png", dimensions.Dx(), dimensions.Dy())
	srcFile, err := os.Open("rainbow.png")
	checkErr(err)
	defer srcFile.Close()
	srcImg, _, _ := image.Decode(srcFile)

	m := image.NewRGBA(image.Rect(0, 0, dimensions.Dx(), dimensions.Dy()))
	draw.Draw(m, m.Bounds(), givenImg, image.Point{0, 0}, draw.Src)
	draw.Draw(m, m.Bounds(), srcImg, image.Point{0, 0}, draw.Over)

	imageFile, err := os.Create(newFilename)
	jpeg.Encode(imageFile, m, &jpeg.Options{100})
	checkErr(err)
}
```
Put them all together and you will have a basic program to add rainbow filter to your photo.
`https://github.com/phucduong86/go-image.git` and `go run main.go` to check it out.
### References materials:  
https://www.devdungeon.com/content/working-images-go  
https://golang.org/pkg/image/  
https://golang.org/pkg/image/png/  
https://golang.org/pkg/image/draw/  
https://blog.golang.org/go-imagedraw-package