//
//  ContentView.swift
//  CoreBT
//
//  Created by Wilsley Germano on 19/08/22.
//

import SwiftUI
import CoreBluetooth


class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var periphals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !periphals.contains(peripheral) {
            self.periphals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "Unnamed device")
        }
    }
}




struct ContentView: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    
    
    var body: some View {
        NavigationView{
            List(bluetoothViewModel.peripheralNames, id: \.self) { peripheral in Text(peripheral)
            }
            .navigationTitle("Peripherals")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
