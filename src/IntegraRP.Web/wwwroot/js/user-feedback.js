window.submitJourneyFeedback = async function submitJourneyFeedback(payload) {
  return fetch('/api/proxy/journey/feedback', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) });
};
