enum SortOrder { aToZ, zToA, region,relevance }


String getSortOrderText(SortOrder sortOrder) {
  switch (sortOrder) {
    case SortOrder.aToZ:
      return 'A-Z';
    case SortOrder.zToA:
      return 'Z-A';
    case SortOrder.region:
      return 'By Region';
    default:
      return 'Relevance'; // Default fallback
  }
}