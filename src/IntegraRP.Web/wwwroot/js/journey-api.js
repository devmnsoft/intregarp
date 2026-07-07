window.IntegraRPJourneyApi = {
  async getWhatToDoNow() {
    const response = await fetch('/api/proxy/journey/what-to-do-now');
    return response.ok ? response.json() : [];
  }
};
