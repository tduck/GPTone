import React, { useState } from 'react';
import { View, Text, TextInput, StyleSheet, ActivityIndicator, ScrollView } from 'react-native';
import { Button } from 'react-native-paper';
import axios from 'axios';

const API_URL = process.env.REACT_APP_SERVER_URL || 'http://localhost:8000';

export default function ToneScreen() {
  const [description, setDescription] = useState('');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<any>(null);
  const [error, setError] = useState<string | null>(null);

  const handleGenerateTone = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await axios.post(`${API_URL}/api/generate_tone`, { description });
      setResult(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    }
    setLoading(false);
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.label}>Describe the tone you want:</Text>
      <TextInput
        style={styles.input}
        placeholder="e.g., warm, spacey reverb with delay"
        value={description}
        onChangeText={setDescription}
        multiline
        numberOfLines={4}
        editable={!loading}
      />
      <Button
        mode="contained"
        onPress={handleGenerateTone}
        disabled={!description || loading}
        style={styles.button}
      >
        {loading ? 'Generating...' : 'Generate Tone'}
      </Button>

      {loading && <ActivityIndicator style={styles.loader} size="large" />}

      {error && (
        <View style={styles.error}>
          <Text style={styles.errorText}>Error: {error}</Text>
        </View>
      )}

      {result && (
        <View style={styles.result}>
          <Text style={styles.resultTitle}>{result.preset_name}</Text>
          <Text style={styles.resultText}>{JSON.stringify(result.effects, null, 2)}</Text>
        </View>
      )}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  label: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 10,
    color: '#333',
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    padding: 12,
    marginBottom: 15,
    borderRadius: 8,
    backgroundColor: '#fff',
    fontSize: 14,
    minHeight: 100,
  },
  button: {
    marginBottom: 15,
  },
  loader: {
    marginVertical: 20,
  },
  error: {
    marginTop: 20,
    padding: 15,
    backgroundColor: '#ffebee',
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: '#f44336',
  },
  errorText: {
    color: '#c62828',
    fontWeight: '600',
  },
  result: {
    marginTop: 20,
    padding: 15,
    backgroundColor: '#e8f5e9',
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: '#4caf50',
  },
  resultTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 10,
    color: '#2e7d32',
  },
  resultText: {
    fontSize: 12,
    color: '#1b5e20',
    fontFamily: 'monospace',
  },
});
