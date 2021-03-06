import AWSMobileClient
import Model
import Prelude
import Store
import SwiftUI
import ViewsComponents

struct TellusView: View {
  @EnvironmentObject var store: Store<AppState, Action>
  @State private var topPickerSelectedIndex: Int = 0
  @State private var middlePickerSelectedIndex: Int = 0
  @State private var bottomPickerSelectedIndex: Int = 0
  @State private var topPickerVisible = false
  @State private var middlePickerVisible = false
  @State private var bottomPickerVisible = false
  @State private var isActivityIndicatorVisible = false

  private let hyperTrackData: HyperTrackData
  private let apiClient: ApiClientProvider
  private let top: [[String: String]]
  private let middle: [[String: String]]
  private let bottom: [[String: String]]

  init(
    hyperTrackData: HyperTrackData,
    apiClient: ApiClientProvider
  ) {
    self.hyperTrackData = hyperTrackData
    self.apiClient = apiClient

    top = [
      ["Not set": ""],
      ["Workforce": Constant.ServerKeys.SignUp.workforceKey],
      ["Logistics": Constant.ServerKeys.SignUp.logisticsKey],
      ["Gig Work": Constant.ServerKeys.SignUp.gigWorkKey],
      ["On-Demand Delivery": Constant.ServerKeys.SignUp.onDemandDeliveryKey],
      ["Ridesharing": Constant.ServerKeys.SignUp.ridesharingKey],
      ["Other": Constant.ServerKeys.SignUp.otherKey]
    ]
    middle = [
      ["Not set": ""],
      ["Commercial use": Constant.ServerKeys.SignUp.commercialUseKey],
      ["COVID-19 response": Constant.ServerKeys.SignUp.covidResponseKey],
      ["Personal use": Constant.ServerKeys.SignUp.personalUseKey],
      ["Public good": Constant.ServerKeys.SignUp.publicGoodKey]
    ]
    bottom = [
      ["Not set": ""],
      ["My workforce": Constant.ServerKeys.SignUp.myWorkforceKey],
      ["My customer's workforce": Constant.ServerKeys.SignUp.myCustomersKey],
      ["Consumers": Constant.ServerKeys.SignUp.consumersKey]
    ]

    if let topIndex = top
      .firstIndex(where: {
        $0.values.first! == self.hyperTrackData.appGoal
      }) {
      _topPickerSelectedIndex = State(initialValue: topIndex)
    }

    if let middleIndex = middle
      .firstIndex(where: {
        $0.values.first! == self.hyperTrackData.appDeviceCount
      }) {
      _middlePickerSelectedIndex = State(initialValue: middleIndex)
    }

    if let bottomIndex = bottom
      .firstIndex(where: {
        $0.values.first! == self.hyperTrackData.appProductState
      }) {
      _bottomPickerSelectedIndex = State(initialValue: bottomIndex)
    }
  }

  var body: some View {
    return GeometryReader { geometry in
      ZStack {
        self.companyInfoView(geometry)
        if self.isActivityIndicatorVisible {
          LottieView()
            .edgesIgnoringSafeArea(.all)
        }
      }
      .navigationBarTitle("")
      .navigationBarHidden(true)
      .background(Color("BackgroundColor"))
      .edgesIgnoringSafeArea(.all)
      .modifier(HideKeyboard())
    }
  }

  private func companyInfoView(_ geometry: GeometryProxy) -> some View {
    return VStack {
      Text("Sign up a new account")
        .font(
          Font.system(size: 24)
            .weight(.semibold))
        .foregroundColor(Color("TitleColor"))
        .padding(.top, 44)
      Text(" ")
        .font(
          Font.system(size: 14)
            .weight(.medium))
        .foregroundColor(Color(UIColor.tertiary_5_m))
      HStack {
        Rectangle()
          .frame(width: 8, height: 8)
          .foregroundColor(Color(UIColor.context_1))
          .cornerRadius(4)
        Rectangle()
          .frame(width: 24, height: 8)
          .foregroundColor(Color(UIColor.tertiary_5_m))
          .cornerRadius(4)
      }
      VStack(spacing: 0) {
        Section {
          HStack {
            Text("My app manages:")
              .font(
                Font.system(size: 16)
                  .weight(.medium))
            Spacer()
            Button(self.top[self.topPickerSelectedIndex].keys
              .first!) {
              self.topPickerVisible.toggle()
              self.middlePickerVisible = false
              self.bottomPickerVisible = false
            }
            .font(
              Font.system(size: 16)
                .weight(.medium))
            .lineLimit(1)
          }
          .padding([.top, .bottom], 13)
          .padding(.trailing, 16)
          .padding(.leading, 38)
          if self.topPickerVisible {
            HStack {
              Spacer()
              Picker(
                selection: self.$topPickerSelectedIndex,
                label: Text("")
              ) {
                ForEach(0 ..< self.top.count) {
                  Text(self.top[$0].keys.first!)
                }
              }
              .onTapGesture {
                self.topPickerVisible.toggle()
                self.middlePickerVisible = false
                self.bottomPickerVisible = false
              }
              Spacer()
            }
            .padding([.leading, .trailing], 38)
          }
        }
        .frame(width: geometry.size.width)
        .background(Color("NavigationBarColor"))
        Spacer()
          .frame(height: 1)
        Section {
          HStack {
            Text("My app is for:")
              .font(
                Font.system(size: 16)
                  .weight(.medium))
            Spacer()
            Button(self.middle[self.middlePickerSelectedIndex].keys
              .first!) {
              self.middlePickerVisible.toggle()
              self.topPickerVisible = false
              self.bottomPickerVisible = false
            }
            .font(
              Font.system(size: 16)
                .weight(.medium))
            .lineLimit(1)
          }
          .padding([.top, .bottom], 13)
          .padding(.trailing, 16)
          .padding(.leading, 38)
          if self.middlePickerVisible {
            HStack {
              Spacer()
              Picker(
                selection: self.$middlePickerSelectedIndex,
                label: Text("")
              ) {
                ForEach(0 ..< self.middle.count) {
                  Text(self.middle[$0].keys.first!)
                }
              }.onTapGesture {
                self.middlePickerVisible.toggle()
                self.topPickerVisible = false
                self.bottomPickerVisible = false
              }
              Spacer()
            }
            .padding([.leading, .trailing], 38)
          }
        }
        .frame(width: geometry.size.width)
        .background(Color("NavigationBarColor"))
        Spacer()
          .frame(height: 1)
        Section {
          HStack {
            Text("My app would track:")
              .font(
                Font.system(size: 16)
                  .weight(.medium))
              .lineLimit(1)
            Spacer()
            Button(self.bottom[self.bottomPickerSelectedIndex].keys
              .first!) {
              self.bottomPickerVisible.toggle()
              self.middlePickerVisible = false
              self.topPickerVisible = false
            }
            .font(
              Font.system(size: 16)
                .weight(.medium))
            .lineLimit(1)
          }
          .padding([.top, .bottom], 13)
          .padding(.trailing, 16)
          .padding(.leading, 38)
          if self.bottomPickerVisible {
            HStack {
              Spacer()
              Picker(
                selection: self.$bottomPickerSelectedIndex,
                label: Text("")
              ) {
                ForEach(0 ..< self.bottom.count) {
                  Text(self.bottom[$0].keys.first!)
                }
              }.onTapGesture {
                self.bottomPickerVisible.toggle()
                self.middlePickerVisible = false
                self.topPickerVisible = false
              }
              Spacer()
            }
            .padding([.leading, .trailing], 38)
          }
        }
        .frame(width: geometry.size.width)
        .background(Color("NavigationBarColor"))
      }
      .padding(.top, 26)
      HStack {
        self.backButton
        self.nextButton
      }
      .padding(.top, 30)
      .padding(.trailing, 16)
      .padding(.leading, 38)
      LiveReadableWithHyperLinkTextView(
        text: .constant("By clicking on the Accept & Continue button I agree to Terms of Service and HyperTrack SaaS Agreement")
      )
      .frame(width: geometry.size.width - 64)
      .clipped()
      Spacer()
    }.any
  }

  var backButton: some View {
    Button(action: {
      self.hyperTrackData.update(.updateAppGoal(self.top[
        self.topPickerSelectedIndex
      ].values.first!))
      self.hyperTrackData.update(.updateAppDeviceCount(self.middle[
        self.middlePickerSelectedIndex
      ].values.first!))
      self.hyperTrackData.update(.updateAppProductState(self.bottom[
        self.bottomPickerSelectedIndex
      ].values.first!))
      self.store.update(.updateFlow(.signUpView))
    }) {
      HStack {
        Text("Back")
          .font(
            Font.system(size: 20)
              .weight(.bold))
          .foregroundColor(Color("SignUpBackButtonTitleColor"))
      }
    }
    .frame(height: 48)
    .padding(.trailing, 24)
  }

  var nextButton: some View {
    Button(action: {
      self.hyperTrackData.update(.updateAppGoal(self.top[
        self.topPickerSelectedIndex
      ].values.first!))
      self.hyperTrackData.update(.updateAppDeviceCount(self.middle[
        self.middlePickerSelectedIndex
      ].values.first!))
      self.hyperTrackData.update(.updateAppProductState(self.bottom[
        self.bottomPickerSelectedIndex
      ].values.first!))
      self.makeSignUp()
    }) {
      HStack {
        Spacer()
        Text("Accept & Continue")
          .font(
            Font.system(size: 20)
              .weight(.bold))
          .foregroundColor(Color.white)
        Spacer()
      }
    }
    .buttonStyle(LiveGreenButtonStyle(false))
    .frame(height: 48)
    .disabled(isNextButtonEnabled())
  }

  private func makeSignUp() {
    isActivityIndicatorVisible.toggle()
    apiClient.signUp(hyperTrackData) {
      switch $0 {
        case .success:
          DispatchQueue.main
            .async { self.store.update(.updateFlow(.verifyView)) }
        case let .failure(error):
          DispatchQueue.main.async { self.isActivityIndicatorVisible.toggle() }
          if let error = error as? AWSMobileClientError {
            self.hyperTrackData.errorMessage = error.message
          } else if case let .appSyncAuthError(message) = error as? LiveError {
            self.hyperTrackData.errorMessage = message
          } else {
            self.hyperTrackData.errorMessage = error.localizedDescription
          }
          DispatchQueue.main
            .async { self.store.update(.updateFlow(.signUpView)) }
      }
    }
  }

  private func isNextButtonEnabled() -> Bool {
    return !(topPickerSelectedIndex > 0 && middlePickerSelectedIndex > 0 && bottomPickerSelectedIndex > 0)
  }
}
