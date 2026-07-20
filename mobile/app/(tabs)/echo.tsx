import React, { useState } from 'react';
import { View, Text, TextInput, StyleSheet, ActivityIndicator } from 'react-native';
import { Button } from 'react-native-paper';
import axios from 'axios';

const API_URL = process.env.REACT_APP_SERVER_URL || 'http://localhost:8000';

export default function EchoScreen() {
  const [message, setMessage] = useState('');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<any>(null);
  const [error, setError] = useState<string | null>(null);

  const handleEcho = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await axios.post(`${API_URL}/echo`, { message });
      setResult(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    }
    setLoading(false);
  };

  const handleHealth = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await axios.get(`${API_URL}/health`);
      setResult(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    }
    setLoading(false);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.label}>Server: {API_URL}</Text>

      <Text style={styles.subtitle}>Test Echo:</Text>
      <TextInput
        style={styles.input}
        placeholder="Type message"
        value={message}
        onChangeText={setMessage}
        editable={!loading}
      />
      <Button mode="contained" onPress={handleEcho} disabled={!message || loading} style={styles.button}>
        Send Echo
      </Button>

      <Button mode="outlined" onPress={handleHealth} disabled={loading} style={styles.button}>
        Check Health
      </Button>

      {loading && <ActivityIndicator style={styles.loader} size="large" />}

      {error && <Text style={styles.error}>Error: {error}</Text>}

      {result && <Text style={styles.result}>{JSON.stringify(result)}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  label: {
    fontSize: 12,
    color: '#666',
    marginBottom: 20,
    fontFamily: 'monospace',
  },
  subtitle: {
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 10,
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    padding: 12,
    marginBottom: 10,
    borderRadius: 8,
    backgroundColor: '#fff',
  },
  button: {
    marginBottom: 10,
  },
  loader: {
    marginVertical: 20,
  },
  error: {
    marginTop: 20,
    padding: 15,
    backgroundColor: '#ffebee',
    borderRadius: 8,
    color: '#c62828',
    fontWeight: '600',
  },
  result: {
    marginTop: 20,
    padding: 15,
    backgroundColor: '#e8f5e9',
    borderRadius: 8,
    color: '#2e7d32',
    fontFamily: 'monospace',
    fontSize: 12,
  },
});
