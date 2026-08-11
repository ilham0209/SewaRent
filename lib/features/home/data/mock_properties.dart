import '../../property/domain/entities/property.dart';

// TODO: Replace mock data with API integration.
const mockProperties = <Property>[
  Property(
    id: 1,
    title: 'Modern 2-Bedroom Apartment in Mont Kiara',
    description:
        'A bright and spacious apartment located minutes from shopping malls '
        'and international schools. The unit comes fully furnished with '
        'high-speed internet ready and a dedicated parking lot.',
    monthlyRent: 2500,
    addressLine1: 'Jalan Kiara 3, Mont Kiara',
    city: 'Kuala Lumpur',
    state: 'Kuala Lumpur',
    postcode: '50480',
    bedrooms: 2,
    bathrooms: 2,
    parkingSpaces: 1,
    isFurnished: true,
    propertyType: 'Apartment',
    availabilityStatus: 'Available',
    landlordName: 'Mr. Tan',
  ),
  Property(
    id: 2,
    title: 'Cozy Studio Near Bangsar South LRT',
    description:
        'Compact and fully furnished studio ideal for young professionals. '
        'Walking distance to the LRT station and the Nexus business park.',
    monthlyRent: 1200,
    addressLine1: 'Jalan Kerinchi, Bangsar South',
    city: 'Kuala Lumpur',
    state: 'Kuala Lumpur',
    postcode: '59200',
    bedrooms: 1,
    bathrooms: 1,
    isFurnished: true,
    propertyType: 'Studio',
    availabilityStatus: 'Available',
    landlordName: 'Ms. Wong',
  ),
  Property(
    id: 3,
    title: 'Family Terrace House in Subang Jaya',
    description:
        'A spacious corner terrace house in a quiet residential neighbourhood. '
        'Close to schools, a medical centre, and the LRT. Unfurnished and '
        'ready for a family.',
    monthlyRent: 1800,
    addressLine1: 'Jalan USJ 2/2, USJ 2',
    city: 'Subang Jaya',
    state: 'Selangor',
    postcode: '47600',
    bedrooms: 3,
    bathrooms: 2,
    parkingSpaces: 2,
    isFurnished: false,
    propertyType: 'Terrace House',
    availabilityStatus: 'Available',
    landlordName: 'Mr. Ahmad',
  ),
  Property(
    id: 4,
    title: 'Condo with KLCC Skyline View',
    description:
        'High-floor condominium offering a stunning city skyline view. '
        'Facilities include a swimming pool, gym, and 24-hour security.',
    monthlyRent: 3200,
    addressLine1: 'Jalan Ampang, KLCC',
    city: 'Kuala Lumpur',
    state: 'Kuala Lumpur',
    postcode: '50450',
    bedrooms: 3,
    bathrooms: 2,
    parkingSpaces: 2,
    isFurnished: true,
    propertyType: 'Condominium',
    availabilityStatus: 'Available',
    landlordName: 'Ms. Lim',
  ),
  Property(
    id: 5,
    title: 'Room in Shared House at Petaling Jaya',
    description:
        'A comfortable private room in a shared house, ideal for students. '
        'Utilities and Wi-Fi are included in the rent.',
    monthlyRent: 650,
    addressLine1: 'Jalan Gasing, Seksyen 5',
    city: 'Petaling Jaya',
    state: 'Selangor',
    postcode: '46000',
    bedrooms: 1,
    bathrooms: 1,
    isFurnished: true,
    propertyType: 'Room',
    availabilityStatus: 'Available',
    landlordName: 'Mr. Raj',
  ),
  Property(
    id: 6,
    title: 'Spacious Studio in Cyberjaya',
    description:
        'Modern studio apartment near the cyber city centre, perfect for '
        'tech workers. Fully furnished with a gym and covered parking.',
    monthlyRent: 950,
    addressLine1: 'Jalan Teknokrat 3, Cyberjaya',
    city: 'Cyberjaya',
    state: 'Selangor',
    postcode: '63000',
    bedrooms: 1,
    bathrooms: 1,
    parkingSpaces: 1,
    isFurnished: true,
    propertyType: 'Studio',
    availabilityStatus: 'Available',
    landlordName: 'Ms. Chen',
  ),
];
