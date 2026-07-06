import React from 'react';
import { ScrollView, Text, View } from 'react-native';

export default function DeliveryRoutesScreen() {
    return (
        <ScrollView style={{ flex: 1, padding: 16, backgroundColor: '#F8FAFC' }}>
            <View style={{ backgroundColor: '#FFFFFF', borderRadius: 16, padding: 16 }}>
                <Text style={{ color: '#071F3A', fontSize: 22, fontWeight: '700' }}>DeliveryRoutesScreen</Text>
                <Text style={{ color: '#111827', marginTop: 8 }}>
                    Tela operacional de campo para rotas, paradas, POD, ocorrências, promotores, checklist e reposição.
                </Text>
                <Text style={{ color: '#2563EB', marginTop: 12 }}>
                    Sem mapa real nesta sprint; coordenadas são exibidas quando retornadas pela API.
                </Text>
            </View>
        </ScrollView>
    );
}
