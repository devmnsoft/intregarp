import React from 'react';
import { Text, TouchableOpacity, View, TextInput, StyleSheet } from 'react-native';
import { colors } from '../theme/colors';
export function AppButton({ title, onPress }: { title: string; onPress: () => void }) { return <TouchableOpacity style={styles.button} onPress={onPress}><Text style={styles.buttonText}>{title}</Text></TouchableOpacity>; }
export function AppCard({ children }: React.PropsWithChildren) { return <View style={styles.card}>{children}</View>; }
export function AppInput(props: React.ComponentProps<typeof TextInput>) { return <TextInput placeholderTextColor="#64748B" style={styles.input} {...props} />; }
export function AppBadge({ text }: { text: string }) { return <Text style={styles.badge}>{text}</Text>; }
export function LoadingState() { return <Text>Carregando...</Text>; }
export function EmptyState({ text }: { text: string }) { return <Text>{text}</Text>; }
export function ErrorState({ text }: { text: string }) { return <Text style={{ color: '#DC2626' }}>{text}</Text>; }
const styles = StyleSheet.create({ button: { backgroundColor: colors.techBlue, borderRadius: 12, padding: 16, marginVertical: 8 }, buttonText: { color: 'white', fontWeight: '700', textAlign: 'center' }, card: { backgroundColor: 'white', borderColor: colors.borderGray, borderWidth: 1, borderRadius: 16, padding: 16, marginVertical: 8 }, input: { backgroundColor: 'white', borderColor: colors.borderGray, borderWidth: 1, borderRadius: 12, padding: 14, marginVertical: 8 }, badge: { alignSelf: 'flex-start', backgroundColor: colors.decisionAmber, color: 'white', borderRadius: 999, paddingHorizontal: 10, paddingVertical: 4 } });
