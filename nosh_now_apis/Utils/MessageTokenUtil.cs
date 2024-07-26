using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Security.Claims;
using System.Security.Cryptography;
using Microsoft.IdentityModel.Tokens;

namespace FirebaseTest.Mobile.Helpers
{
    public static class GoogleOAuthUtility
    {
        public static string CreateJwtForFirebaseMessaging()
        {
            string privateKey = "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCepfAO/KIy5IW0\nm8HGsY7okEboRPgpY0Wq6B/2CPmdpqBHrfAZDmwi3OYmqrJsBckaBTiidshGsYQC\ncuGPAioJ/ESIZi5jaMne15FIw9DJBw4F0nmhOX1QbOSwGMUiylA6M3P+0BKs9p4d\n2pzii4B80kg3K2/tN2yHJ2VOuIDiT2bu3pgvTxiVgk8fBVuppWxUjD4vIkQBRrjK\n8Pv3ePi/Pvz17MtkCb2EDRTvDV3rdPDiW41XeDj77xfM4AWbdcRxJl7i1pvzjfXs\nLkUhucvVHBl1SVjYe7NWZh6r7eOmiwjzRarsxvgn+GR8Ljl9X4JfOjwFlhaVw9mC\nWRy9ewr1AgMBAAECggEAJiguAUTE9C2fdO2DYTkicJAG5eV0tGuifXUf/spw0viZ\nEzRkC3q7CnWLy2AB0tZfZGk+EmE0UUBvyjD8TCuOleE9UHsXDCTPbM/3KwOhyz/t\noPva8iqEF9xg8nO6sl/rhNwMOYys+TnFlNOYKSq5SAxBfzdsz6albSpOBO1+Xi+u\ntUJC4OqkZDykNKr7bF1U9P6ivkNpLWBQwVrWfeauIZMasa2pjg75yGY9yehFkrCR\nU5UaDBj+TgSddYQhV3EVIxONTGH9IDyYkKjFqstW7xhWVBPYZUBMtLrhjnYZUhiY\nzppqD0grxsYDzGsVXSSC5wEo6r7kGUQDhEGKSG43/wKBgQDUOWyy7cR8ycNhVPxC\nr4BWp3E32YzQgEjV/y1jrXzF1W+kp/IWPepFonZ6cXOhDzxoLthmnYWWZXIzOV3Q\nWv0JtJWEpDtwW4d2/3LX9JHz1A64ZX7KGnPqi4j/k5R3V7Gn0nFSQLy4nUy/9TbU\nUvsf8hVkJFzMGa1LKbMcKmaggwKBgQC/X2iFrrjE0qO+AtPZhpXfrWu29SqHbVDX\n3OnBewndf1JM7mclP9cVmbBLNyuM6s2T/pRp1uFv+OsQieaMNqnIymiFE9B5LpOZ\n/IE+4U9IEZCmHsErscw2d8we2qOI33YGs+nILhpbwNqmvLGcXYd4/CVGYrePS64E\nCGqmCgNdJwKBgHsoF/x+HtiL/eYt+3Z3gnLHGNzgUudsitglDaIau53TDsbu734Y\n0Cs47KiBzihZPyT2in6CS1PL60nusJKJOu627U3cQOIjO6nC9FJ+i3SES0aXH80J\nLNufvhETA8V+DorlhP3Gs74vCqsbEoaE4VbYlbFXqMKI5BgKSva9ZHEhAoGAGGfs\nho//1Gogo8zsg6NcXchaIl0l7VuNodn0nc45NdxU/Kay1NdNcN3G0/DXRwNy8FrZ\nRp425fbS06sikeMuyAK4TbB3N90uycagHQrS95f14JmvfQkRyCiDCbRMgtoszTII\nsJTgm67+s6EA7bYn3tAZWN6iFk5KhQ0lvMMuJqUCgYBWKn9aMOgA7+DLtlyVyF2n\nLV5p8DleGWoCFfznoyjvqKQjsQm6NbXw+MAJ+jaycq5j0HTrBD5nCT1AeBr1EAog\n+XQr8WQqGH1zqbrNJzn5B3/ez8ERwSANXJLLvyRbB/Qd4JBJCvsMkV1v664ybwLT\neplwdW9dz9r8q2oo5H2wRA==\n-----END PRIVATE KEY-----\n";
            
            long unixSeconds = DateTimeOffset.Now.ToUnixTimeSeconds();
            long expirationUnixSeconds = DateTimeOffset.Now.AddYears(1).ToUnixTimeSeconds();
            RSAParameters rsaParameters = DecodeRsaParameters(privateKey);
            
            var tokenHandler = new JwtSecurityTokenHandler();
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                {
                    new Claim("iss", "{client_email field from your service account JSON file}"),
                    new Claim("scope", "https://www.googleapis.com/auth/firebase.messaging"),
                    new Claim("aud", "https://oauth2.googleapis.com/token"),
                    new Claim("exp", expirationUnixSeconds.ToString()),
                    new Claim("iat", unixSeconds.ToString()),
                }),
                Expires = DateTimeOffset.Now.AddYears(1).DateTime,
                SigningCredentials = new SigningCredentials(new RsaSecurityKey(rsaParameters), SecurityAlgorithms.RsaSha256) // RS256 with Sha hash required by Google OAuth
            };
            
            SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }
        
        // Code of DecodeRsaParameters and below helpers methods and classes copied from https://github.com/googleapis/google-api-dotnet-client 
        private static RSAParameters DecodeRsaParameters(string pkcs8PrivateKey)
        {
            if (string.IsNullOrWhiteSpace(pkcs8PrivateKey))
            {
                throw new ArgumentException("Empty PrivateKey");
            }
            
            const string PrivateKeyPrefix = "-----BEGIN PRIVATE KEY-----";
            const string PrivateKeySuffix = "-----END PRIVATE KEY-----";

            pkcs8PrivateKey = pkcs8PrivateKey.Trim();
            if (!pkcs8PrivateKey.StartsWith(PrivateKeyPrefix) || !pkcs8PrivateKey.EndsWith(PrivateKeySuffix))
            {
                throw new ArgumentException($"PKCS8 data must be contained within '{PrivateKeyPrefix}' and '{PrivateKeySuffix}'.", nameof(pkcs8PrivateKey));
            }

            string base64PrivateKey =
                pkcs8PrivateKey.Substring(PrivateKeyPrefix.Length, pkcs8PrivateKey.Length - PrivateKeyPrefix.Length - PrivateKeySuffix.Length);
            // FromBase64String() ignores whitespace, so further Trim()ing isn't required.
            byte[] pkcs8Bytes = Convert.FromBase64String(base64PrivateKey);

            object ans1 = Asn1.Decode(pkcs8Bytes);
            object[] parameters = (object[])((object[])ans1)[2];

            var rsaParmeters = new RSAParameters
            {
                Modulus = TrimLeadingZeroes((byte[])parameters[1]),
                Exponent = TrimLeadingZeroes((byte[])parameters[2], alignTo8Bytes: false),
                D = TrimLeadingZeroes((byte[])parameters[3]),
                P = TrimLeadingZeroes((byte[])parameters[4]),
                Q = TrimLeadingZeroes((byte[])parameters[5]),
                DP = TrimLeadingZeroes((byte[])parameters[6]),
                DQ = TrimLeadingZeroes((byte[])parameters[7]),
                InverseQ = TrimLeadingZeroes((byte[])parameters[8]),
            };

            return rsaParmeters;
        }
        
        private static byte[] TrimLeadingZeroes(byte[] bs, bool alignTo8Bytes = true)
        {
            int zeroCount = 0;
            while (zeroCount < bs.Length && bs[zeroCount] == 0) zeroCount += 1;

            int newLength = bs.Length - zeroCount;
            if (alignTo8Bytes)
            {
                int remainder = newLength & 0x07;
                if (remainder != 0)
                {
                    newLength += 8 - remainder;
                }
            }

            if (newLength == bs.Length)
            {
                return bs;
            }

            byte[] result = new byte[newLength];
            if (newLength < bs.Length)
            {
                Buffer.BlockCopy(bs, bs.Length - newLength, result, 0, newLength);
            }
            else
            {
                Buffer.BlockCopy(bs, 0, result, newLength - bs.Length, bs.Length);
            }
            return result;
        }
        
        private class Asn1
        {
            private enum Tag
            {
                Integer = 2,
                OctetString = 4,
                Null = 5,
                ObjectIdentifier = 6,
                Sequence = 16,
            }

            private class Decoder
            {
                public Decoder(byte[] bytes)
                {
                    _bytes = bytes;
                    _index = 0;
                }

                private byte[] _bytes;
                private int _index;

                public object Decode()
                {
                    Tag tag = ReadTag();
                    switch (tag)
                    {
                        case Tag.Integer:
                            return ReadInteger();
                        case Tag.OctetString:
                            return ReadOctetString();
                        case Tag.Null:
                            return ReadNull();
                        case Tag.ObjectIdentifier:
                            return ReadOid();
                        case Tag.Sequence:
                            return ReadSequence();
                        default:
                            throw new NotSupportedException($"Tag '{tag}' not supported.");
                    }
                }

                private byte NextByte() => _bytes[_index++];

                private byte[] ReadLengthPrefixedBytes()
                {
                    int length = ReadLength();
                    return ReadBytes(length);
                }

                private byte[] ReadInteger() => ReadLengthPrefixedBytes();

                private object ReadOctetString()
                {
                    byte[] bytes = ReadLengthPrefixedBytes();
                    return new Decoder(bytes).Decode();
                }

                private object ReadNull()
                {
                    int length = ReadLength();
                    if (length != 0)
                    {
                        throw new InvalidDataException("Invalid data, Null length must be 0.");
                    }
                    return null;
                }

                private int[] ReadOid()
                {
                    byte[] oidBytes = ReadLengthPrefixedBytes();
                    List<int> result = new List<int>();
                    bool first = true;
                    int index = 0;
                    while (index < oidBytes.Length)
                    {
                        int subId = 0;
                        byte b;
                        do
                        {
                            b = oidBytes[index++];
                            if ((subId & 0xff000000) != 0)
                            {
                                throw new NotSupportedException("Oid subId > 2^31 not supported.");
                            }
                            subId = (subId << 7) | (b & 0x7f);
                        } while ((b & 0x80) != 0);
                        if (first)
                        {
                            first = false;
                            result.Add(subId / 40);
                            result.Add(subId % 40);
                        }
                        else
                        {
                            result.Add(subId);
                        }
                    }
                    return result.ToArray();
                }

                private object[] ReadSequence()
                {
                    int length = ReadLength();
                    int endOffset = _index + length;
                    if (endOffset < 0 || endOffset > _bytes.Length)
                    {
                        throw new InvalidDataException("Invalid sequence, too long.");
                    }
                    List<object> sequence = new List<object>();
                    while (_index < endOffset)
                    {
                        sequence.Add(Decode());
                    }
                    return sequence.ToArray();
                }

                private byte[] ReadBytes(int length)
                {
                    if (length <= 0)
                    {
                        throw new ArgumentOutOfRangeException(nameof(length), "length must be positive.");
                    }
                    if (_bytes.Length - length < 0)
                    {
                        throw new ArgumentException("Cannot read past end of buffer.");
                    }
                    byte[] result = new byte[length];
                    Array.Copy(_bytes, _index, result, 0, length);
                    _index += length;
                    return result;
                }

                private Tag ReadTag()
                {
                    byte b = NextByte();
                    int tag = b & 0x1f;
                    if (tag == 0x1f)
                    {
                        // A tag value of 0x1f (31) indicates a tag value of >30 (spec section 8.1.2.4)
                        throw new NotSupportedException("Tags of value > 30 not supported.");
                    }
                    else
                    {
                        return (Tag)tag;
                    }
                }

                private int ReadLength()
                {
                    byte b0 = NextByte();
                    if ((b0 & 0x80) == 0)
                    {
                        return b0;
                    }
                    else
                    {
                        if (b0 == 0xff)
                        {
                            throw new InvalidDataException("Invalid length byte: 0xff");
                        }
                        int byteCount = b0 & 0x7f;
                        if (byteCount == 0)
                        {
                            throw new NotSupportedException("Lengths in Indefinite Form not supported.");
                        }
                        int result = 0;
                        for (int i = 0; i < byteCount; i++)
                        {
                            if ((result & 0xff800000) != 0)
                            {
                                throw new NotSupportedException("Lengths > 2^31 not supported.");
                            }
                            result = (result << 8) | NextByte();
                        }
                        return result;
                    }
                }

            }

            public static object Decode(byte[] bs) => new Decoder(bs).Decode();

        }
    }
}