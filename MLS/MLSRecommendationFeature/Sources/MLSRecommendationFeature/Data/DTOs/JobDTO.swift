struct JobResponseDTO: Decodable {
    let success: Bool
    let code: String?
    let message: String?
    let data: JobDTO?
}

struct JobDTO: Decodable {
    let jobId: Int
    let jobName: String
    let jobLevel: Int
    let parentJobId: Int?
}
