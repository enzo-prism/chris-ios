import SwiftUI
import SwiftData

struct MyQuestionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PatientQuestion.createdAt, order: .reverse) private var questions: [PatientQuestion]
    @State private var newQuestion = ""

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "My Questions", systemImage: AppSymbol.questions)
                            TextField("Add a question", text: $newQuestion, axis: .vertical)
                                .textFieldStyle(.roundedBorder)

                            Text("Stored only on this device. Do not include medical details.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)

                            PrimaryButton(title: "Add question", systemImage: AppSymbol.confirm) {
                                addQuestion()
                            }
                            .disabled(newQuestion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }

                    if questions.isEmpty {
                        GlassCard {
                            Text("No questions yet. Add one above and bring it to your next visit.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(questions) { question in
                                    QuestionRow(question: question)

                                    if question.id != questions.last?.id {
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("My Questions")
    }

    private func addQuestion() {
        let trimmed = newQuestion.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let question = PatientQuestion(text: trimmed)
        modelContext.insert(question)
        try? modelContext.save()
        newQuestion = ""
    }
}

private struct QuestionRow: View {
    @Bindable var question: PatientQuestion
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Toggle("", isOn: $question.isAnswered)
                .labelsHidden()

            VStack(alignment: .leading, spacing: 4) {
                Text(question.text)
                    .font(.subheadline)
                Text(DateFormatter.shortDateTime.string(from: question.createdAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .onChange(of: question.isAnswered) { _, _ in
            try? modelContext.save()
        }
    }
}
