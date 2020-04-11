using System;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Collections.Generic;

using exoplanet.Crypto.Ciphers;
using exoplanet.Services;
using exoplanet.Models;

namespace exoplanet.Authentication
{
    public class Authenticator
    {
        private readonly ICipher cipher;
        private readonly SecretService service;

        private readonly JsonSerializerOptions options;

        public Authenticator(ICipher cipher, SecretService service)
        {
            this.cipher = cipher;
            this.service = service;

            this.options = new JsonSerializerOptions();
            this.options.IgnoreNullValues = true;
        }

        public async Task<IEnumerable<string>> ExtractTokenContentAsync(
            string token,
            string secretName,
            string ownerName)
        {
            var data = await DecryptTokenAsync(token, secretName, ownerName)
                .ConfigureAwait(false);

            if (data == null)
                return Enumerable.Empty<string>();

            try
            {
                var obj = JsonSerializer.Deserialize(
                    data,
                    typeof(IEnumerable<string>), 
                    options) as IEnumerable<string>;

                return obj ?? Enumerable.Empty<string>();
            }
            catch (JsonException)
            {
                return Enumerable.Empty<string>();
            }
        }

        public async Task<string> GenerateTokenAsync(
            string secretName, 
            string ownerName, 
            IEnumerable<string> content)
        {
            var secret = await service.GetSecretAsync(secretName)
                .ConfigureAwait(false);

            if (secret == null || secret.Value == null)
            {
                secret = Secret.Generate(secretName, 9);
                await service.AddSecretAsync(secret);
            }

            var data = JsonSerializer.Serialize(
                content,
                typeof(IEnumerable<string>),
                options);

            this.cipher.Encrypt(
                Encoding.UTF8.GetBytes(secret.Value),
                Encoding.UTF8.GetBytes(data),
                Encoding.UTF8.GetBytes(ownerName),
                out var checksum,
                out var tokenData);

            var owner = Encoding.UTF8.GetBytes(ownerName);

            return Token.Create(tokenData, owner, checksum).ToString();
        }

        private async Task<string> DecryptTokenAsync(
            string token,
            string secretName,
            string ownerName)
        {
            var secret = await service.GetSecretAsync(secretName)
                .ConfigureAwait(false);
            
            if (secret == null || secret.Value == null)
                return null;

            var _token = Token.FromString(token);

            if (!this.cipher.TryDecrypt(
                    Encoding.UTF8.GetBytes(secret.Value),
                    _token.Data,
                    _token.Owner,
                    _token.Checksum,
                    out var data))
                return null;
            
            return Encoding.UTF8.GetString(data);
        }
    }
}
