import SwiftUI
import UIKit

@main
struct OxideLauncherApp: App {
    var body: some Scene {
        WindowGroup {
            LauncherView()
                .preferredColorScheme(.dark)
        }
    }
}

struct LauncherView: View {
    @State private var compact = UserDefaults.standard.bool(forKey: "compactMenu")
    @State private var highContrast = UserDefaults.standard.bool(forKey: "highContrast")
    @State private var selectedFileName = "Файл не выбран"
    @State private var showFilePicker = false
    @State private var showInfo = false

    private let green = Color(red: 0.67, green: 1.0, blue: 0.38)

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.08, green: 0.14, blue: 0.09), Color.black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18).fill(green.gradient).frame(width: 62, height: 62)
                            Image(systemName: "gamecontroller.fill").font(.system(size: 27, weight: .black)).foregroundStyle(.black)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("SURVIVAL TOOLKIT").font(.system(size: 10, weight: .black, design: .rounded)).tracking(2).foregroundStyle(green)
                            Text("OXIDE LAUNCHER").font(.system(size: 22, weight: .black, design: .rounded))
                            Text("iOS • версия 0.1").font(.caption).foregroundStyle(.secondary)
                        }
                    }.padding(.top, 18)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("ТВОЙ ИГРОВОЙ ЦЕНТР").font(.system(size: 11, weight: .bold)).tracking(1.5).foregroundStyle(green)
                        Text("Готов к выживанию?").font(.system(size: 27, weight: .heavy, design: .rounded))
                        Text("Запуск игры, выбор доступных файлов и локальные настройки.").font(.subheadline).foregroundStyle(.secondary)
                        Button {
                            if let url = URL(string: "oxide://") {
                                UIApplication.shared.open(url, options: [:]) { success in
                                    if !success { showInfo = true }
                                }
                            }
                        } label: {
                            Label("Открыть Oxide", systemImage: "play.fill")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity).padding(.vertical, 16)
                        }
                        .buttonStyle(.borderedProminent).tint(green).foregroundStyle(.black)
                        .alert("Не удалось открыть игру", isPresented: $showInfo) {
                            Button("Открыть App Store") {
                                if let url = URL(string: "https://apps.apple.com/app/id1579424683") { UIApplication.shared.open(url) }
                            }
                            Button("ОК", role: .cancel) {}
                        } message: {
                            Text("У игры может не быть общедоступной ссылки запуска. Проверь, что Oxide установлена.")
                        }
                    }.padding(20).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24)).overlay(RoundedRectangle(cornerRadius: 24).stroke(green.opacity(0.25)))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("ФАЙЛЫ").font(.system(size: 12, weight: .black)).tracking(1.5).foregroundStyle(green)
                        HStack(spacing: 12) {
                            Image(systemName: "folder.badge.plus").font(.title2).frame(width: 42, height: 42).background(.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Выбрать файл").font(.headline)
                                Text(selectedFileName).font(.caption).foregroundStyle(.secondary).lineLimit(2)
                            }
                            Spacer()
                            Button("Выбрать") { showFilePicker = true }.buttonStyle(.bordered).tint(green)
                        }.padding(14).background(Color.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 17))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("НАСТРОЙКИ").font(.system(size: 12, weight: .black)).tracking(1.5).foregroundStyle(green)
                        Toggle("Компактный интерфейс", isOn: $compact).tint(green)
                            .onChange(of: compact) { value in UserDefaults.standard.set(value, forKey: "compactMenu") }
                        Toggle("Высокая контрастность", isOn: $highContrast).tint(green)
                            .onChange(of: highContrast) { value in UserDefaults.standard.set(value, forKey: "highContrast") }
                    }.padding(18).background(Color.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 18))

                    Text("Примечание: это лаунчер и файловый интерфейс. iOS изолирует данные других приложений, поэтому выбор файла не даёт доступа ко всем файлам Oxide и сам по себе не добавляет игровых модификаций.")
                        .font(.system(size: 11)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                    Text("OXIDE LAUNCHER • DEMO").font(.system(size: 10, weight: .bold)).tracking(2).foregroundStyle(.gray.opacity(0.7)).frame(maxWidth: .infinity).padding(.bottom, 18)
                }.padding(.horizontal, 18)
            }
        }
        .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.item, .data, .archive], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                selectedFileName = urls.first?.lastPathComponent ?? "Файл не выбран"
            case .failure:
                selectedFileName = "Не удалось открыть файл"
            }
        }
    }
}
