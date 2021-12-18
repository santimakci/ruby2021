User.create!([
    { id: 1, email: 'admin@polycon.com', password: 'admin123', password_confirmation: 'admin123', role: 3 },
    { id: 2, email: 'assistant@polycon.com', password: 'assistant123', password_confirmation: 'assistant123', role: 2 },
    { id: 3, email: 'patient@polycon.com', password: 'patient123', password_confirmation: 'patient123', role: 1 },
    { id: 4, email: 'patient2@polycon.com', password: 'patient123', password_confirmation: 'patient123', role: 1 }

])
Professional.create!([
    { id: 1, nameAndSurname: 'Dr. Santiago' },
    { id: 2, nameAndSurname: 'Dr. Lucas' },
    { id: 3, nameAndSurname: 'Dr. Carlos' },
])
Appointment.create!([
    { date: '2021-12-22', hour: '12:00', professional_id: 1, user_id: 4 },
    { date: '2021-12-28', hour: '12:00', professional_id: 1, user_id: 3 },
    { date: '2021-12-24', hour: '10:00', professional_id: 1, user_id: 4 },
    { date: '2021-12-24', hour: '12:00', professional_id: 1, user_id: 3 },
    { date: '2021-12-21', hour: '12:00', professional_id: 2, user_id: 3 },
    { date: '2021-12-24', hour: '16:00', professional_id: 2, user_id: 4 }
])




