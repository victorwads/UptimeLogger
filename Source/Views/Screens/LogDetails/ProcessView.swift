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
    @State private var sortingOption: SortingOption = .command

    enum SortingOption {
        case command
        case user
        case cpu
        case mem
    }
    
    var sortedProccess: [ProcessLogInfo] {
        let processes = proccess.filter({
            searchText.isEmpty || ($0.user + $0.command).localizedCaseInsensitiveContains(searchText)
        })
        switch sortingOption {
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
        Divider()
            .padding(.top, 0)
        HStack {
            Picker("Sort by", selection: $sortingOption) {
                Text("Command").tag(SortingOption.command)
                Text("User").tag(SortingOption.user)
                Text("%CPU").tag(SortingOption.cpu)
                Text("%Mem").tag(SortingOption.mem)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            HStack {
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            Text("\(sortedProccess.count) processes")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(10)
        List(sortedProccess, id: \.id) { item in
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                    Text(item.user)
                    Image(systemName: "number")
                    Text(String(item.pid))
                    Text(String(format: "%.1f%% CPU", item.cpu))
                        .foregroundColor(.green)
                    Text(String(format: "%.1f%% MEM", item.mem))
                        .foregroundColor(.blue)
                    Text(item.started)
                    Text(item.time)
                }
                .font(.caption)
                Text(item.command)
            }
            Divider()
        }
    }
}


struct ProcessView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessView(
            proccess: .constant([])
        )
    }
}
