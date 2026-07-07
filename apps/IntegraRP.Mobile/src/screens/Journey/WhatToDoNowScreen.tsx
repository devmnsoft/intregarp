import React from 'react';
import { Text, View, Pressable } from 'react-native';

export function WhatToDoNowScreen() {
  return (
    <View>
      <Text>WhatToDoNowScreen</Text>
      <Text>Próxima tarefa, instruções claras, checklist e estado vazio operacional.</Text>
      <Pressable accessibilityRole="button"><Text>Continuar</Text></Pressable>
    </View>
  );
}
