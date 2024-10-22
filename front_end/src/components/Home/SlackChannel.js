import React from 'react';
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import { BarChart, Bar, CartesianGrid, XAxis, YAxis, Tooltip } from 'recharts';


function SlackChannel({ channel, messages }) {
    const [showGraph, setShowGraph] = React.useState(false);

    const handleClick = () => {
        setShowGraph(!showGraph);
    };

    const getDayHour = (timestamp) => {
        const date = new Date(timestamp * 1000);
        date.setMinutes(0);
        date.setSeconds(0);
        date.setMilliseconds(0);
        return date.getTime();
    }

    const getInitialData = () => {
        const now = Date.now();
        const data = [];
        for (let i = 0; i < 48; i++) {
            data.unshift({
                name: new Date(now - i * 60 * 60 * 1000).toLocaleString('en-US', { timeZone: 'America/Chicago' }),
                count: 0
            });
        }
        return data;
    }

    const aggregateData = (messages) => {
        const data = getInitialData();
        messages.forEach(message => {
            const dayHour = getDayHour(message.ts);
            data.forEach(item => {
                const start = new Date(item.name).getTime();
                const end = start + 60 * 60 * 1000; // Add one hour to the start time
                if (dayHour >= start && dayHour < end) {
                    item.count++;
                }
            });
        });
        console.log(data)
        return data;
    };

    const twoDaysAgo = Date.now() - 2 * 24 * 60 * 60 * 1000;
    const recentMessages = messages.filter(({ ts }) => ts * 1000 >= twoDaysAgo);
    const data = aggregateData(recentMessages);

    return (
        <Box sx={{ mt: 2, mb: 2 }} onClick={handleClick}>
            <Typography variant="h6">{channel}</Typography>
            <Typography variant="body1">Number of messages: {recentMessages.length}</Typography>
            {showGraph && (
                <BarChart width={500} height={300} data={data}>
                    <Bar dataKey="count" fill="#8884d8" activeOpacity={0} />
                    <CartesianGrid stroke="#ccc" />
                    <XAxis dataKey="name" />
                    <YAxis />
                    <Tooltip />
                </BarChart>
            )}
        </Box>
    );
}

export default SlackChannel;
