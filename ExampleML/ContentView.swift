//
//  ContentView.swift
//  ExampleML
//
//  Created by Ivo Junior Bettini on 01/07/22.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    let model = MobileNetV2()
    @State private var classificationLabel: Text = Text("")
    
    let photos = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    @State private var currentIndex: Int = 0
    
    @State var textButton: String = "Classify"
    @State var isTapped: Bool = false
    
    var body: some View {
        
        VStack {
            Image(photos[currentIndex])
                .resizable()
                .frame(width: 300, height: 300)
                .clipShape(Circle())
            
            Spacer()
        }.scaledToFit()
        
        HStack {
            Button("Back") {
                if self.currentIndex >= self.photos.count {
                    self.currentIndex = self.currentIndex - 1
                } else {
                    self.currentIndex = 0
                }
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.red)
            .clipShape(Capsule())

            
            Button("Next") {
                if self.currentIndex < self.photos.count - 1 {
                    self.currentIndex = self.currentIndex + 1
                } else {
                    self.currentIndex = 0
                }
                classificationLabel = Text("")
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.green)
            .clipShape(Capsule())

            
        }
        
        //The button we will use to classify the image using our model
        
        Button(action: {
            classifyImage()
            isTapped.toggle()
            switch isTapped {
            case true:
                textButton = "Closed"
            default:
                textButton = "Classify"
                classificationLabel = Text("")
            }
        }, label: {
            Text("\(textButton)")
        })
        .padding()
        .foregroundColor(Color.white)
        .background(Color.blue)
        .clipShape(Capsule())
        .padding()
        
        VStack{
            classificationLabel
                .padding()
                .font(.custom("Avenir-Heavy", size: 14))
        }
        
        /*
        Button("Classify") {
            classifyImage()
        }
        .padding()
        .foregroundColor(Color.white)
        .background(Color.blue)
        .clipShape(Capsule())
        .padding()
        
        // The Text View that we will use to display the results of the classification
        VStack{
            //ScrollView{
                Text(classificationLabel)
                   .padding()
                   .font(.custom("Avenir-Heavy", size: 14))
            }
        //}
         */
            
    }
    
    
   
    
    private func classifyImage() {
        
        let currentImageName = photos[currentIndex]
        
        guard let image = UIImage(named: currentImageName),
                    let resizedImage = image.resizeImageTo(size: CGSize(width: 224, height: 224)),
                    let buffer = resizedImage.convertToBuffer() else {
            return
        }

        let output = try? model.prediction(image: buffer)
        
        if let output = output {
                
                let results = output.classLabelProbs.sorted { $0.1 > $1.1 }

            let result = results.prefix(10).map { (key, value) in
                    return "\(key) = \(String(format: "%.2f", value * 100))%"
                }.joined(separator: "\n")

                self.classificationLabel = Text(result)
            }
        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


