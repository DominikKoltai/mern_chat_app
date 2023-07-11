const request = require('supertest');
const index = require('./index');
const User = require('./models/User'); // Assuming you have a User model imported
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Mocking dependencies
jest.mock('./models/User');
jest.mock('bcryptjs');
jest.mock('jsonwebtoken');

describe('POST /register', () => {
    test('should register a new user and return the user ID', async () => {
      const mockUserId = 'mockUserId';
      const mockToken = 'mockToken';
      const mockHashedPassword = 'mockHashedPassword';
  
      // Mock the bcrypt.hashSync function
      bcrypt.hashSync.mockReturnValue(mockHashedPassword);
  
      // Mock the User.create function
      User.create.mockResolvedValue({ _id: mockUserId });
  
      // Mock the jwt.sign function
      jwt.sign.mockImplementation((_, __, ___, callback) => {
        callback(null, mockToken);
      });
  
      // Make a request to the /register endpoint
      const response = await request(index)
        .post('/register')
        .send({ username: 'testuser', password: 'testpassword' });
  
      // Verify the response
      expect(response.statusCode).toBe(201);
      expect(response.headers['set-cookie']).toContain(`token=${mockToken}`);
      expect(response.body).toEqual({ id: mockUserId });
  
      // Verify the interactions with the mocked functions
      expect(bcrypt.hashSync).toHaveBeenCalledWith('testpassword', expect.anything());
      expect(User.create).toHaveBeenCalledWith({
        username: 'testuser',
        password: mockHashedPassword,
      });
      expect(jwt.sign).toHaveBeenCalledWith(
        { userId: mockUserId, username: 'testuser' },
        expect.anything(),
        {},
        expect.any(Function)
      );
    });
  });  