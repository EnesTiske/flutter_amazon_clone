import React, { useState, useEffect } from 'react';
import { 
  Box, 
  Button, 
  TextField, 
  Typography, 
  Container,
  Paper,
  Alert,
  Snackbar,
  Grid,
  Divider,
  useTheme,
  CircularProgress
} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { QRCodeSVG } from 'qrcode.react';
import { styled } from '@mui/material/styles';
import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import QrCodeIcon from '@mui/icons-material/QrCode2';

const StyledPaper = styled(Paper)(({ theme }) => ({
  padding: theme.spacing(4),
  transition: 'transform 0.2s ease-in-out',
  '&:hover': {
    transform: 'translateY(-5px)',
  },
  background: 'rgba(255, 255, 255, 0.9)',
  backdropFilter: 'blur(10px)',
}));

const StyledButton = styled(Button)(({ theme }) => ({
  background: 'linear-gradient(45deg, #2196F3 30%, #21CBF3 90%)',
  border: 0,
  borderRadius: 3,
  boxShadow: '0 3px 5px 2px rgba(33, 203, 243, .3)',
  color: 'white',
  height: 48,
  padding: '0 30px',
  '&:hover': {
    background: 'linear-gradient(45deg, #21CBF3 30%, #2196F3 90%)',
  },
}));

const StyledTextField = styled(TextField)(({ theme }) => ({
  '& .MuiOutlinedInput-root': {
    '&:hover fieldset': {
      borderColor: theme.palette.primary.main,
    },
    '&.Mui-focused fieldset': {
      borderColor: theme.palette.primary.main,
    },
  },
}));

const Login = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [showSuccess, setShowSuccess] = useState(false);
  const [qrToken, setQrToken] = useState('');
  const [qrExpired, setQrExpired] = useState(false);

  // Generate token for QR code
  const generateQRToken = async () => {
    try {
      const response = await axios.post('http://localhost:3000/api/generate-qr-token');
      setQrToken(response.data.token);
      setQrExpired(false);
    } catch (error) {
      setError('Error occurred while generating QR code');
    }
  };

  // Check QR code status
  const checkQRStatus = async () => {
    if (!qrToken) return;
    
    try {
      const response = await axios.get(`http://localhost:3000/api/check-qr-status/${qrToken}`);
      if (response.data.status === 'authenticated') {
        localStorage.setItem('token', response.data.token);
        localStorage.setItem('userInfo', JSON.stringify(response.data.userInfo));
        setShowSuccess(true);
        setTimeout(() => {
          navigate('/home');
        }, 2000);
      } else if (response.data.status === 'expired') {
        setQrExpired(true);
      }
    } catch (error) {
      console.error('Error checking QR status:', error);
    }
  };

  // Generate new QR code when component loads and every 30 seconds
  useEffect(() => {
    generateQRToken();
    const qrInterval = setInterval(generateQRToken, 30000);
    return () => clearInterval(qrInterval);
  }, []);

  // Check QR code status every 2 seconds
  useEffect(() => {
    if (!qrToken) return;
    
    const statusInterval = setInterval(checkQRStatus, 2000);
    return () => clearInterval(statusInterval);
  }, [qrToken]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('http://localhost:3000/api/signin', {
        email: email,
        password: password
      }, {
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        }
      });

      if (response.data.token) {
        localStorage.setItem('token', response.data.token);
        localStorage.setItem('userInfo', JSON.stringify({
          email: response.data.email,
          name: response.data.name,
          address: response.data.address
        }));
        setShowSuccess(true);
        setTimeout(() => {
          navigate('/home');
        }, 2000);
      }
    } catch (error) {
      setError(error.response?.data?.message || 'An error occurred during login');
    }
  };

  return (
    <Box
      sx={{
        minHeight: '100vh',
        background: 'linear-gradient(120deg, #f6f7f9 0%, #e9ecef 100%)',
        py: 8,
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      <Container component="main" maxWidth="lg">
        <Box
          sx={{
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            textAlign: 'center',
            p: 3,
          }}
        >
          <Typography
            variant="h3"
            sx={{
              fontWeight: 700,
              background: 'linear-gradient(45deg, #2196F3 30%, #21CBF3 90%)',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
              mb: 2,
            }}
          >
            Welcome Back
          </Typography>
          <Typography variant="body1" color="text.secondary" sx={{ mb: 4 }}>
            Sign in to continue to your account
          </Typography>
        </Box>

        <Grid container spacing={4} sx={{ mt: 8 }}>
          {/* Manual Login Section */}
          <Grid item xs={12} md={6}>
            <StyledPaper elevation={6}>
              <Box
                sx={{
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                }}
              >
                <Box
                  sx={{
                    width: 56,
                    height: 56,
                    borderRadius: '50%',
                    bgcolor: 'primary.main',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    mb: 2,
                  }}
                >
                  <LockOutlinedIcon sx={{ color: 'white', fontSize: 30 }} />
                </Box>
                <Typography component="h1" variant="h5" gutterBottom fontWeight="bold">
                  Sign In
                </Typography>
                <Box component="form" onSubmit={handleSubmit} sx={{ mt: 3, width: '100%' }}>
                  <StyledTextField
                    margin="normal"
                    required
                    fullWidth
                    id="email"
                    label="Email Address"
                    name="email"
                    autoComplete="email"
                    autoFocus
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    sx={{ mb: 2 }}
                  />
                  <StyledTextField
                    margin="normal"
                    required
                    fullWidth
                    name="password"
                    label="Password"
                    type="password"
                    id="password"
                    autoComplete="current-password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    sx={{ mb: 3 }}
                  />
                  <StyledButton
                    type="submit"
                    fullWidth
                    size="large"
                  >
                    Sign In
                  </StyledButton>
                </Box>
              </Box>
            </StyledPaper>
          </Grid>

          {/* QR Code Section */}
          <Grid item xs={12} md={6}>
            <StyledPaper elevation={6} sx={{ height: '100%' }}>
              <Box
                sx={{
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  height: '100%',
                }}
              >
                <Box
                  sx={{
                    width: 56,
                    height: 56,
                    borderRadius: '50%',
                    bgcolor: 'secondary.main',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    mb: 2,
                  }}
                >
                  <QrCodeIcon sx={{ color: 'white', fontSize: 30 }} />
                </Box>
                <Typography component="h1" variant="h5" gutterBottom fontWeight="bold">
                  Quick Access
                </Typography>
                <Typography
                  variant="body1"
                  color="text.secondary"
                  sx={{ mb: 4, textAlign: 'center', maxWidth: '80%' }}
                >
                  Scan the QR code with your mobile app for instant access
                </Typography>
                <Paper
                  elevation={3}
                  sx={{
                    p: 3,
                    bgcolor: 'white',
                    borderRadius: 2,
                    position: 'relative',
                    transition: 'transform 0.3s ease',
                    '&:hover': {
                      transform: 'scale(1.02)',
                    },
                  }}
                >
                  {qrExpired ? (
                    <Box
                      sx={{
                        position: 'absolute',
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        bgcolor: 'rgba(255, 255, 255, 0.95)',
                        borderRadius: 2,
                        zIndex: 1,
                      }}
                    >
                      <StyledButton
                        onClick={generateQRToken}
                        startIcon={<QrCodeIcon />}
                      >
                        Generate New Code
                      </StyledButton>
                    </Box>
                  ) : null}
                  <Box sx={{ position: 'relative' }}>
                    <QRCodeSVG 
                      value={qrToken || 'loading...'}
                      size={200}
                      level="H"
                      includeMargin={true}
                      style={{
                        display: 'block',
                        margin: '0 auto',
                      }}
                    />
                    {!qrToken && (
                      <Box
                        sx={{
                          position: 'absolute',
                          top: '50%',
                          left: '50%',
                          transform: 'translate(-50%, -50%)',
                        }}
                      >
                        <CircularProgress size={40} />
                      </Box>
                    )}
                  </Box>
                </Paper>
                <Box
                  sx={{
                    display: 'flex',
                    alignItems: 'center',
                    mt: 3,
                    gap: 1,
                  }}
                >
                  <CircularProgress
                    size={20}
                    thickness={6}
                    sx={{
                      color: 'success.main',
                    }}
                  />
                  <Typography variant="body2" color="text.secondary">
                    QR code refreshes automatically
                  </Typography>
                </Box>
              </Box>
            </StyledPaper>
          </Grid>
        </Grid>

        {/* Error message */}
        <Snackbar
          open={!!error}
          autoHideDuration={6000}
          onClose={() => setError('')}
          anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
        >
          <Alert
            onClose={() => setError('')}
            severity="error"
            sx={{ width: '100%' }}
            elevation={6}
            variant="filled"
          >
            {error}
          </Alert>
        </Snackbar>

        {/* Success message */}
        <Snackbar
          open={showSuccess}
          autoHideDuration={2000}
          onClose={() => setShowSuccess(false)}
          anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
        >
          <Alert
            severity="success"
            sx={{ width: '100%' }}
            elevation={6}
            variant="filled"
          >
            Giriş başarılı! Yönlendiriliyorsunuz...
          </Alert>
        </Snackbar>
      </Container>
    </Box>
  );
};

export default Login;