import Testing

@testable import MLSAuthFeature
import MLSAuthFeatureInterface
import MLSAuthFeatureTesting

import RxSwift

@Suite("TermsAgreementReactor - 동의 상태 관리")
struct TermsAgreementReactorTests {

    // MARK: - 전체 동의 토글

    @Test("전체동의 ON: 모든 항목 true")
    func toggleTotalOn_setsAllAgreementsTrue() {
        let reactor = makeSUT()
        let state = reactor.reduce(state: reactor.initialState, mutation: .setAgreeState(type: .total, isOn: true))

        #expect(state.isTotalAgree == true)
        #expect(state.isAgeAgree == true)
        #expect(state.isServiceTermsAgree == true)
        #expect(state.isPersonalInformationAgree == true)
        #expect(state.isMarketingAgree == true)
    }

    @Test("전체동의 OFF: 모든 항목 false")
    func toggleTotalOff_setsAllAgreementsFalse() {
        let reactor = makeSUT()
        var state = reactor.reduce(state: reactor.initialState, mutation: .setAgreeState(type: .total, isOn: true))
        state = reactor.reduce(state: state, mutation: .setAgreeState(type: .total, isOn: false))

        #expect(state.isTotalAgree == false)
        #expect(state.isAgeAgree == false)
        #expect(state.isServiceTermsAgree == false)
        #expect(state.isPersonalInformationAgree == false)
        #expect(state.isMarketingAgree == false)
    }

    // MARK: - bottomButton 활성화

    @Test("필수 3개(나이·서비스·개인정보) 동의: bottomButton 활성화")
    func requiredFieldsAgreed_enablesBottomButton() {
        let reactor = makeSUT()
        var state = reactor.initialState
        state = reactor.reduce(state: state, mutation: .setAgreeState(type: .age, isOn: true))
        state = reactor.reduce(state: state, mutation: .setAgreeState(type: .serviceTerms, isOn: true))
        state = reactor.reduce(state: state, mutation: .setAgreeState(type: .personalInfo, isOn: true))

        #expect(state.bottomButtonIsEnabled == true)
    }

    @Test("마케팅만 동의: bottomButton 비활성화")
    func onlyMarketingAgreed_disablesBottomButton() {
        let reactor = makeSUT()
        let state = reactor.reduce(state: reactor.initialState, mutation: .setAgreeState(type: .marketing, isOn: true))

        #expect(state.bottomButtonIsEnabled == false)
    }

    @Test("필수 항목 하나 누락: bottomButton 비활성화")
    func missingOneRequired_disablesBottomButton() {
        let reactor = makeSUT()
        var state = reactor.initialState
        state = reactor.reduce(state: state, mutation: .setAgreeState(type: .age, isOn: true))
        state = reactor.reduce(state: state, mutation: .setAgreeState(type: .serviceTerms, isOn: true))
        // personalInfo 미동의

        #expect(state.bottomButtonIsEnabled == false)
    }

    // MARK: - isTotalAgree 조건

    @Test("필수 3개만 동의: isTotalAgree false")
    func requiredOnlyAgreed_isTotalAgreeFalse() {
        let reactor = makeSUT()
        var state = reactor.initialState
        state = reactor.reduce(state: state, mutation: .setAgreeState(type: .age, isOn: true))
        state = reactor.reduce(state: state, mutation: .setAgreeState(type: .serviceTerms, isOn: true))
        state = reactor.reduce(state: state, mutation: .setAgreeState(type: .personalInfo, isOn: true))

        #expect(state.isTotalAgree == false)
    }

    @Test("필수 3개 + 마케팅 동의: isTotalAgree true")
    func allIncludingMarketing_isTotalAgreeTrue() {
        let reactor = makeSUT()
        let state = reactor.reduce(state: reactor.initialState, mutation: .setAgreeState(type: .total, isOn: true))

        #expect(state.isTotalAgree == true)
    }
}

// MARK: - Helpers

private func makeSUT() -> TermsAgreementReactor {
    TermsAgreementReactor(
        credential: Credential(token: "", providerID: ""),
        socialPlatform: .kakao,
        socialSignUpUseCase: MockSocialSignUpUseCase(),
        tokenRepository: MockTokenRepository()
    )
}
