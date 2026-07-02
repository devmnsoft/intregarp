import React, { useState } from 'react';
import { SafeAreaView, ScrollView, Text, View } from 'react-native';
import { AppBadge, AppButton, AppCard, AppInput } from './components/AppComponents';
import { colors } from './theme/colors';

const screens = [
  'dashboard',
  'tasks',
  'detail',
  'execution',
  'form',
  'checklist',
  'evidence',
  'signature',
  'approval',
  'notifications',
  'ai',
  'settings'
];

export default function App() {
  const [screen, setScreen] = useState('login');
  const [message, setMessage] = useState('');

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: colors.lightBackground }}>
      <ScrollView contentContainerStyle={{ padding: 20 }}>
        <Text style={{ fontSize: 28, fontWeight: '800', color: colors.institutionalBlue }}>
          IntegraRP Field
        </Text>

        {screen === 'login' ? (
          <AppCard>
            <AppInput placeholder="E-mail" autoCapitalize="none" />
            <AppInput placeholder="Senha" secureTextEntry />
            <AppInput placeholder="Tenant" />
            <AppButton title="Entrar" onPress={() => setScreen('dashboard')} />
          </AppCard>
        ) : (
          <>
            <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 8 }}>
              {screens.map(item => (
                <AppButton key={item} title={item} onPress={() => setScreen(item)} />
              ))}
            </View>

            <AppCard>
              <AppBadge text="Online-first, preparado para fila offline futura" />
              <Text style={{ marginTop: 12, fontSize: 20, fontWeight: '700' }}>{screen}</Text>
              <Text>Status, prazo, prioridade e próxima ação aparecem em cards grandes para campo.</Text>

              {screen === 'ai' && (
                <>
                  <AppInput
                    placeholder="Pergunte ao assistente governado"
                    value={message}
                    onChangeText={setMessage}
                  />
                  <Text>
                    IA governada. Sem acesso direto ao banco. Confiança e fallback humano são exibidos na
                    resposta.
                  </Text>
                </>
              )}
            </AppCard>
          </>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}
