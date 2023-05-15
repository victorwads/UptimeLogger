//
//  SearchBar.swift
//  UptimeLogger
//
//  Created by Victor Wads on 19/04/23.
//

import SwiftUI

struct ProcessView: View {

    @Binding var proccess: [ProcessLogInfo]
    @State private var searchText: String = ""
    @State private var sortingOption: SortingOption = .none
    @State private var searchOption: SearchOption = .contains

    enum SearchOption {
        case contains
        case notcontains
    }

    enum SortingOption {
        case none
        case command
        case user
        case cpu
        case mem
    }
    
    var sortedProccess: [ProcessLogInfo] {
        let processes = proccess.filter({
            let contains = ($0.user + $0.command).localizedCaseInsensitiveContains(searchText)
            
            return searchText.isEmpty ||
            ( searchOption == .contains ? contains : !contains )
            
        })
        switch sortingOption {
        case .none:
            return processes.sorted { $0.pid < $1.pid }
        case .command:
            return processes.sorted { $0.command < $1.command }
        case .user:
            return processes.sorted { $0.user < $1.user }
        case .cpu:
            return processes.sorted { $0.cpu > $1.cpu }
        case .mem:
            return processes.sorted { $0.mem > $1.mem }
        }
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Picker("", selection: $searchOption) {
                    Text("==").tag(SearchOption.contains)
                        .help(.key(.resultsContains))
                    Text("!=").tag(SearchOption.notcontains)
                        .help(.key(.resultsContainsNot))
                }.font(.subheadline)
                .pickerStyle(.segmented)
                .frame(maxWidth: 80)
                TextField(.key(.resultsSearch), text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.animation(.default)
            Picker(.key(.resultsSort), selection: $sortingOption) {
                Text("ID").tag(SortingOption.none)
                Text("Command").tag(SortingOption.command)
                Text("User").tag(SortingOption.user)
                Text("%CPU").tag(SortingOption.cpu)
                Text("%Mem").tag(SortingOption.mem)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .frame(maxWidth: 430)
            Text("\(sortedProccess.count) / \(proccess.count)")
                .font(.headline)
                .foregroundColor(.secondary)
                .transition(.scale)
        }
        .padding(10)
        List(sortedProccess, id: \.pid) { item in
            HStack {
                Image(systemName: "number")
                Text(String(item.pid))
                Image(systemName: "person.crop.circle.fill")
                Text(item.user)
                HStack {
                    Text(item.command)
                        .font(.body)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                Text(String(format: "%.1f%% CPU", item.cpu))
                    .foregroundColor(.green)
                Text(String(format: "%.1f%% MEM", item.mem))
                    .foregroundColor(.blue)
            }
            .font(.caption)
            Divider()
        }
        .listStyle(InsetListStyle())
    }
}


struct ProcessView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProcessView(
                proccess: .constant([
                    ProcessLogInfo.example,
                    ProcessLogInfo.example,
                    ProcessLogInfo.example,
                    ProcessLogInfo.example,
                ])
            )
        }.frame(width: 1000, height: 700)
        LogDetailsScreen(
            provider: LogsProviderMock(),
            urlFileName: "mockFileName",
            logFile: LogsProviderMock.fullUnexpected
        ).frame(width: 1000, height: 700)
    }
}
