//
//  HomeView.swift
//  PasswordManager
//
//  Created by Pushpendra Rajput  on 09/04/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @StateObject private var viewModel = PasswordViewModel()
    @State private var showingAddSheet = false
    @State private var showingDetailSheet = false
    
    @State private var selectedPassword: PasswordEntity?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack {
                    HStack {
                        Text("Password Manager")
                            .font(.custom("SFPRODISPLAYREGULAR", size: 18))
                            .padding(.top, 20)
                            .padding(.leading, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .padding(.horizontal)
                        .padding(.top,10)
                    
                    if viewModel.passwordItems.isEmpty {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("Please add new account and make sure password must be at least 8 characters long and include at least 1 number, and 1 special character.")
                                    .font(.custom("SFPRODISPLAYREGULAR", size: 18))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.blue)
                    } else {
                     
                        List {
                            ForEach(viewModel.passwordItems) { item in
                                HStack {
                                    Text(item.serviceName)
                                        .font(.custom("SFPRODISPLAYREGULAR", size: 20))
                                    
                                    Text(item.maskedPassword)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
                                .listRowSeparator(.hidden)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(hex: "#EDEDED"), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                .onTapGesture {
                                    let request: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
                                    request.predicate = NSPredicate(format: "accountName == %@", item.serviceName)
                                    
                                    do {
                                        if let result = try viewModel.context.fetch(request).first {
                                            selectedPassword = result
                                            showingDetailSheet = true
                                        }
                                    } catch {
                                        print("Error selecting password: \(error)")
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .padding(.top, 20)
                        .sheet(item: $selectedPassword) { password in
                            PasswordDetailSheet(passwordEntity: password, viewModel: viewModel)
                                .presentationDetents([.height(420)])
                                .presentationDragIndicator(.hidden)
                        }
                    }
                }
                
                // Floating button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddSheet = true
                        }) {
                            Image("plus_icon")
                                .frame(width: 60, height: 60)
                                .shadow(radius: 4)
                        }
                        .padding()
                        
                        .sheet(isPresented: $showingAddSheet) {
                            AddPasswordSheet(viewModel: viewModel)
                                .frame(height: 420)
                                .presentationDetents([.height(420)])
                                .presentationDragIndicator(.hidden)
                        }
                    }
                }
            }
            .navigationBarTitle("") // Hides default title
            .navigationBarHidden(true) // Hides default bar
        }
    }
}

