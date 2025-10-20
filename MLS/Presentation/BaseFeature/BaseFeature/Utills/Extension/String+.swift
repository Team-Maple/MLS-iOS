extension String {
    public func isOnlyKorean() -> Bool {
        let initialConsonants = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ"
        return self.allSatisfy { initialConsonants.contains($0) }
    }

}
