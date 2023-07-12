const request = require('supertest');
const app = require('./index');
const User = require('./models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

jest.mock('./models/User');
jest.mock('bcryptjs');
jest.mock('jsonwebtoken');

describe('POST /login', () => {
  test('should login user and return user ID', async () => {
    const mockUsername = 'testuser';
    const mockPassword = 'testpassword';
    const mockToken = 'mockToken';
    const mockFoundUser = { _id: 'mockUserId', password: 'mockHashedPassword' };

    User.findOne.mockResolvedValue(mockFoundUser);

    bcrypt.compareSync.mockReturnValue(true);

    jwt.sign.mockImplementation((_, __, ___, callback) => {
      callback(null, mockToken);
    });

    const response = await request(app)
      .post('/login')
      .send({ username: mockUsername, password: mockPassword });

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual({ id: mockFoundUser._id });

    expect(User.findOne).toHaveBeenCalledWith({ username: mockUsername });
    expect(bcrypt.compareSync).toHaveBeenCalledWith(mockPassword, mockFoundUser.password);
    expect(jwt.sign).toHaveBeenCalledWith(
      { userId: mockFoundUser._id, username: mockUsername },
      expect.anything(),
      {},
      expect.any(Function)
    );
  });
});

describe('GET /profile', () => {
  test('should return user data for authenticated user', async () => {
    const mockToken = 'mockToken';
    const mockUserData = { userId: 'mockUserId', username: 'testuser' };

    jwt.verify.mockImplementation((_, __, ___, callback) => {
      callback(null, mockUserData);
    });

    const response = await request(app)
      .get('/profile')
      .set('Cookie', `token=${mockToken}`);

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(mockUserData);

    expect(jwt.verify).toHaveBeenCalledWith(
      mockToken,
      expect.anything(),
      {},
      expect.any(Function)
    );
  });

  test('should return unauthorized for unauthenticated user', async () => {
    const response = await request(app).get('/profile');

    expect(response.statusCode).toBe(401);
    expect(response.body).toBe('no token');
  });
});